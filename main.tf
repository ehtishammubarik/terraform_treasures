terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 4.0"
		}
	}
}
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region 
}

data "aws_vpc" "get_vpc_details" {
  id = var.vpc_id
}

resource "aws_instance" "jobnav2022_ec2" {
	count         		   = var.number_of_instances
	ami           		   = var.jobnav_instance_ami
	instance_type 		   = var.jobnav_instance_type
    key_name               = var.jobnav2022_key_name
	subnet_id 			   = aws_subnet.jobnav2022_subnet_pub_1a.id 
	vpc_security_group_ids = [aws_security_group.jobnav2022_security_group.id]
	root_block_device {
	  volume_size = 40
	}
    tags = {
		Name = " Jobnav Deployment ${count.index}"
	}
}
