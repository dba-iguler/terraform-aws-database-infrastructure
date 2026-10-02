terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_subnet" "lab" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = [var.availability_zone]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_instance" "linux" {
  for_each                    = var.node_names
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.lab.id
  key_name                    = aws_key_pair.lab.key_name
  vpc_security_group_ids      = [aws_security_group.lab.id]
  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = each.key
  }
}

resource "aws_key_pair" "lab" {
  key_name   = "terraform-lab"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "lab" {
  name        = "terraform-lab-sg"
  description = "SSH access from my public IP"
  vpc_id      = data.aws_subnet.lab.vpc_id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  dynamic "ingress" {
    for_each = [2379, 2380, 8008, 5432]

    content {
      description = "Cluster internal TCP ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      self        = true
    }
  }
  egress {
    description = "Outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ips" {
  value = {
    for name, vm in aws_instance.linux :
    name => vm.public_ip
  }
}

output "private_ips" {
  value = {
    for name, vm in aws_instance.linux :
    name => vm.private_ip
  }
}
