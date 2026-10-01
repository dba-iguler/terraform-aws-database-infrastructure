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

