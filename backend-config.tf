# Backend configuration for Terraform state.

terraform {
  backend "s3" {
    bucket = "panopticon-rabbit-terraform-state"
    key    = "network/terraform.tfstate"
    region = "us-west-2"
  }
}