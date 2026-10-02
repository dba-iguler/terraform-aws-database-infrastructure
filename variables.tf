variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "node_names" {
  description = "Names of the Linux nodes"
  type        = set(string)
  default = [
    "terraform-linux-1",
    "terraform-linux-2",
    "terraform-linux-3"
  ]
}

variable "ssh_allowed_cidr" {
  description = "Public IP range allowed to connect over SSH"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used by the lab environment"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "eu-central-1a"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}
