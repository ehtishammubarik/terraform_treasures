
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

# ---------------------------------------------------------------------------
# Security. Added during remediation; see docs/remediation.md.
# ---------------------------------------------------------------------------

variable "db_password" {
  description = "Database master password, supplied at apply time from a secret manager."
  type        = string
  sensitive   = true
  # No default, deliberately. A default is what ends up committed, which is
  # exactly how this repository leaked one.
}

variable "db_username" {
  description = "Database master username."
  type        = string
  default     = "app"
}

variable "db_identifier" {
  description = "RDS instance identifier, also used for the final snapshot name."
  type        = string
  default     = "app-db"
}

variable "db_allowed_cidrs" {
  description = "CIDRs permitted to reach the database on 5432. Never 0.0.0.0/0."
  type        = list(string)

  validation {
    condition     = !contains(var.db_allowed_cidrs, "0.0.0.0/0")
    error_message = "A database must not be reachable from the internet. Use a bastion, a VPN, or SSM Session Manager."
  }
}

variable "bastion_allowed_cidrs" {
  description = "CIDRs permitted to reach the bastion. Never 0.0.0.0/0."
  type        = list(string)

  validation {
    condition     = !contains(var.bastion_allowed_cidrs, "0.0.0.0/0")
    error_message = "A bastion open to the internet is not a bastion. Use SSM Session Manager if you need ad-hoc access."
  }
}
