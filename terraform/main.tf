terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-bucket-v2-anurag"
    key    = "medusa/terraform.tfstate"
    region = "us-east-1"
  }
}
