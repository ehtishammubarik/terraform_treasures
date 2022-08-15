
## Provider Details for AWS 
# variable "provider_source" {
#   description = "Soruce string for provider"
#   type        = string
# }
# variable "provider_version" {
#   description = "Version for aws default provider"
#   type        = string
# }

## Account Authentication Details

variable "aws_access_key" {
    description = "Access key for aws authentication"
    type        = string
}
variable "aws_secret_key" {
    description = "Secret key for aws authentication"
    type        = string
}
variable "aws_region" {
    description = "Region to deploy AWS resources in default provider"
    type        = string
}
## Project Details
variable "project_name" {
    description = "Name of the project"
    type        = string
}

## VPC Details
variable "vpc_id" {
    type        = string
    description = "ID of VPS to get details in datasource. "
}


## EC2 Details
variable "jobnav_instance_ami" {
    type        = string
    description = "AMI to create instances for jobnav2022"
}

variable "number_of_instances" {
    type        = number
    description = "Count for instances to be created for jobnav2022"
  
}
variable "jobnav_instance_type" {
    type        = string
    description = "Instance type for deployments of jobnav2022 "
}

variable "jobnav2022_key_name" {
    type        = string 
    description = "Name of keyPair to be used to access instances of jobnav2022"
}

variable "ses_iam_policy" {
    description = "Naame of ses IAM policy"
    type        = string
}