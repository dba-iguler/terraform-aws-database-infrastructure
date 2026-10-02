# Terraform AWS Database Infrastructure
Terraform labs for building and changing AWS infrastructure used in my database platform work.

## What is in this repo

- EC2 provisioning
- Security groups
- Variables and outputs
- Terraform plan / apply / destroy
- Saved plans
- Infrastructure change scenarios
- Replacement and restart impact checks
- Basic reusable structure for database lab environments

## Current focus

Right now I'm using this repo to practice:
- provisioning Linux servers for PostgreSQL labs
- reviewing 'terraform plan' before changes
- understanding when a change is in-place vs replacement
- testing infrastructure changes safely
- rebuilding and destroying lab environments cleanly

## Example workflow

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform plan -out=rebuild.tfplan
terraform apply "rebuild.tfplan"

Notes
This is a hands-on lab repo. I keep the examples simple and add scenarios as I test them.

## Verified lab deployment

On 2026-10-02, I rebuilt the lab from this repository:

- Created three Ubuntu EC2 instances using 'for_each'.
- Used 't3.micro' instances with encrypted 10 GiB gp3 root volumes.
- Restricted SSH access to my public IP.
- Allowed TCP ports 2379, 2380, 5432 and 8008 within the shared security group.
- Verified SSH access, memory and disk layout on all three nodes.
- Checked the Terraform state and confirmed a subsequent plan returned no changes.

### PowerShell workflow

Copy 'terraform.tfvars.example' to 'terraform.tfvars' and fill in the environment values.


aws login --profile terraform-iam
$env:AWS_PROFILE = "terraform"
aws sts get-caller-identity

terraform init
terraform fmt -check
terraform validate
terraform plan "-out=rebuild.tfplan"
terraform apply "rebuild.tfplan"

terraform state list
terraform plan

The 'terraform' AWS profile uses a credential process configured to export credentials from 'terraform-iam'. These profile names are specific to my local setup.

Set 'AWS_PROFILE' again when opening a new PowerShell session. Applying a saved plan starts execution without another approval prompt.

### State and scope

This lab currently uses local state. State files, saved plans and local variable values are excluded from Git.

The deployment uses an existing default VPC and subnet. All three nodes are in one availability zone. PostgreSQL, Patroni and etcd installation will be handled in a later Ansible lab.