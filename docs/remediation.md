# Remediation plan

This repository was published as-is from client infrastructure work. An audit
on 2026-07-29 found issues that need clearing before it is used as a reference
by anyone, including its author.

Ordered by severity. Nothing here is a style opinion.

## P0: a database password is public

`postgresql_db.tf` sets `password` to a base64 string. Base64 is encoding, not
encryption, and it is present in git history as well as at HEAD.

**Rotate the credential at the database.** Removing it from the file does not
revoke it, and the repository is public, so it should be treated as known.

Then:

```hcl
variable "db_password" {
  description = "Database master password, supplied at apply time."
  type        = string
  sensitive   = true
  # No default. A default is what ships.
}
```

## P0: PostgreSQL is reachable from the internet

`postgresql_db.tf` opens 5432 to `0.0.0.0/0`. `security_groups.tf` opens a
dynamic ingress block to `0.0.0.0/0` as well.

A database port open to the world is exploited by automated scanners within
hours, not weeks.

Ingress CIDRs belong in a variable so an environment can be locked down without
editing the module:

```hcl
variable "db_allowed_cidrs" {
  description = "CIDRs permitted to reach the database. Never 0.0.0.0/0."
  type        = list(string)
  validation {
    condition     = !contains(var.db_allowed_cidrs, "0.0.0.0/0")
    error_message = "A database must not be open to the internet."
  }
}
```

The `validation` block matters: it makes the rule enforceable rather than
advisory.

## P1: destroying the database loses it

`skip_final_snapshot = true`, no `deletion_protection`, no `storage_encrypted`.

A `terraform destroy` against this configuration is unrecoverable data loss,
and there is nothing in the code to stop it.

```hcl
storage_encrypted       = true
deletion_protection     = true
skip_final_snapshot     = false
final_snapshot_identifier = "${var.name}-final-${formatdate("YYYYMMDDhhmm", timestamp())}"

lifecycle {
  prevent_destroy = true
}
```

## P1: a client name is in a public repository

`jobnav2022` appears across 11 files. Whether or not that engagement is public,
publishing a client's infrastructure topology is not something to do by
accident.

Replace with a `name` variable throughout.

## P2: nothing is pinned or documented

- `main.tf` declares `required_providers` but pins no versions, so a plan run
  today and a plan run next month are not the same plan.
- No `required_version` on Terraform itself.
- `us-east-1a` is hardcoded in `postgresql_db.tf`.
- No module has a README. No `examples/` exists.

## P2: flat layout

Thirteen `.tf` files at the root, describing one specific environment. Nothing
here is reusable as a module despite the repository's name.

Target:

```
modules/vpc/          networking, subnets, route tables, NAT
modules/rds-postgres/ database, parameter group, security group
modules/bastion/      instance, elastic IP, security group
environments/dev/     composition, backend config, tfvars.example
examples/vpc-simple/  runnable, minimal, tested in CI
```

Restructuring is a state migration, not a refactor. Use `moved` blocks so
Terraform does not destroy and recreate.

## Order of work

1. Rotate the database credential. Nothing else matters until this is done.
2. Consider making the repository private until P0 items are cleared.
3. Close the 5432 ingress.
4. Add deletion protection, encryption, and final snapshot.
5. Variabilise the client name.
6. Pin Terraform and providers.
7. Restructure into modules, with `moved` blocks.
8. Add module READMEs and a tested `examples/`.
9. Flip the checkov job from advisory to blocking.

## Why the CI security job is advisory

`scan` runs with `soft_fail: true` and `continue-on-error`. If it blocked
today, every PR would fail on pre-existing findings and the gate would be
disabled within a week.

It goes blocking at step 9, once the existing findings are cleared. A gate
everybody bypasses is worse than no gate, because it looks like coverage.
