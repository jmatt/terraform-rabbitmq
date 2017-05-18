# Servers in cluster.
variable "count" {
  default = 3
}

data "terraform_remote_state" "s3-panopticon-rabbit-terraform-state" {
    backend = "s3"
    config {
        bucket = "panopticon-rabbit-terraform-state"
        key = "network/terraform.tfstate"
        region = "us-west-2"
    }
}
