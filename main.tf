terraform {
  # Pinned. An unpinned provider means a plan run today and a plan run next
  # month are not the same plan, which makes reviewing a plan meaningless.
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Credentials come from the provider's default chain: environment variables,
  # a shared config profile, or an instance role. Passing them as Terraform
  # variables writes them into state in plaintext, which is how a credential
  # ends up somewhere nobody thought to look.
}

data "aws_vpc" "get_vpc_details" {
  id = var.vpc_id
}

resource "aws_instance" "jobnav2022_ec2" {
  count                  = var.number_of_instances
  ami                    = var.jobnav_instance_ami
  instance_type          = var.jobnav_instance_type
  key_name               = var.jobnav2022_key_name
  subnet_id              = aws_subnet.jobnav2022_subnet_pub_1a.id
  vpc_security_group_ids = [aws_security_group.jobnav2022_security_group.id]
  root_block_device {
    volume_size = 40
  }
  tags = {
    Name = " Jobnav Deployment ${count.index}"
  }
}
