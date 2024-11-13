terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.70.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "aws_instance" "sampleserver" {
    ami = "ami-09da212cf18033880"
    instance_type = "t2.micro"
    

    tags = {
        Name = "sampleserver"
    }
  
}