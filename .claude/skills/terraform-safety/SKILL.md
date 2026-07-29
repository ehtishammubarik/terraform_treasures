---
name: terraform-safety
description: Safety rules for changing Terraform in this repo. Use before writing or reviewing any .tf change, and before proposing any apply. Covers blast radius, state, secrets, and the resources that replace silently.
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# Terraform safety

Infrastructure code fails differently from application code. It does not throw;
it deletes. And the deletion is usually invisible in the diff, because what
destroys a database is a changed attribute, not a removed resource.

## Always plan first

```bash
terraform -chdir=<dir> fmt -check -recursive
terraform -chdir=<dir> validate
terraform -chdir=<dir> plan -no-color | tee /tmp/plan.txt
grep -E 'will be (destroyed|replaced)' /tmp/plan.txt
```

**Read the destroy and replace lines before anything else.** If there are none,
most of the risk is gone. If there are any, each one needs an answer to: is the
data recoverable, and does whoever owns it know?

## Resources that replace on an innocent-looking change

| Resource | Replaced by a change to |
|---|---|
| `aws_db_instance` | identifier, engine version, subnet group, AZ |
| `aws_ebs_volume` | availability zone, type, encryption |
| `aws_s3_bucket` | name |
| `aws_eks_cluster` | name, role ARN, subnets |
| `aws_instance` | AMI, subnet, user_data outside a launch template |
| `aws_efs_file_system` | encryption, performance mode |

None of these look dangerous in a diff. All of them are in a plan.

## Secrets

A secret in a `.tf` file is public the moment it is pushed, and it stays in
history after you remove it. **Rotate first, clean history second.** Removing
it from HEAD does not revoke it.

Base64 is not encryption. It is more dangerous than plaintext, because a
reviewer's eye slides past it.

```hcl
variable "db_password" {
  description = "Database master password. Supplied at apply time from a secret manager."
  type        = string
  sensitive   = true
  # deliberately no default
}
```

No default. A default is what gets shipped.

## Network defaults

`0.0.0.0/0` is the single most common serious finding in Terraform review.

| Port | `0.0.0.0/0` verdict |
|---|---|
| 5432, 3306, 27017, 6379, 1433 | Blocking. A database on the public internet |
| 22, 3389 | Blocking. Use a bastion, SSM Session Manager, or a VPN |
| 80, 443 behind a load balancer | Usually correct |
| Egress `-1` to `0.0.0.0/0` | Common and usually accepted, but say so rather than letting it pass unremarked |

Ingress CIDRs belong in a variable, never hardcoded. That way an environment
can be locked down without editing the module.

## State

- Remote backend with locking, always. Local state on a root module is one
  laptop away from unrecoverable.
- State contains every secret in plaintext. The backend bucket is encrypted,
  versioned, and blocks public access, or the secrets are public.
- Moving resources between modules is a **state migration**, not a refactor.
  Use `moved` blocks; do not let Terraform destroy and recreate.

## Cost

Every infrastructure PR has a monthly bill attached and it is invisible in the
diff. Flag instance type changes, node counts, NAT gateways (one per AZ is a
common accidental triple at roughly 32 dollars each per month before data
charges), provisioned IOPS, and cross-AZ traffic.

State the delta per month, or say you did not compute it.

## Before proposing an apply

1. Plan output pasted, and read.
2. Every destroy and replace accounted for.
3. Backups confirmed to exist for anything stateful in the plan.
4. Rollback stated. "Revert the commit" is not a rollback if the resource was
   destroyed.
5. Blast radius named: what breaks, who notices, how long to recover.
6. Explicit approval on **that** plan, not on the idea of the change.
