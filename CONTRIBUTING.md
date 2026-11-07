# Contributing

Thank you for considering a contribution. This repository is public, holds
infrastructure code, and has had a security incident in its past (a committed
database credential). That history is why the rules below are strict. They are
not bureaucracy; every one of them maps to a real failure this repo already had.

## Claim an issue first

- Comment on the open issue you want to work on to claim it, before writing
  code. This prevents two people building the same thing.
- **One issue, one PR.** If you find a second problem mid-branch, open a new
  issue for it rather than widening the branch.
- If you can no longer work on a claimed issue, say so in the issue thread so
  someone else can pick it up.

## Attach the plan, not just the diff

The diff is not the change; the plan is the change. A one-line edit can destroy
a database. Every PR that touches `.tf` files MUST include the `terraform plan`
output (not just the code diff) so reviewers approve the actual effect, not a
guess at it. Without the plan, the PR will not be reviewed.

## The six non-negotiables

1. **Never commit a credential.** Not plaintext, not base64. Base64 is
   encoding, not encryption, and a reviewer skims past it precisely because it
   looks encrypted. Secrets come from a secret manager or a `sensitive`
   variable supplied at apply time.
2. **Never commit `.tfstate`, real `.tfvars`, or `.terraform/`.** State
   contains every secret the plan touched, in plaintext.
3. **`0.0.0.0/0` on a database, SSH, or RDP port is blocking**, always. On 443
   behind a load balancer it is usually correct. Say which one you mean.
4. **Pin everything.** `required_version` and every provider. An unpinned
   provider makes a plan irreproducible, which makes review meaningless.
5. **Stateful resources get `prevent_destroy`**, `deletion_protection`,
   encryption at rest, and a backup retention above zero. `skip_final_snapshot
   = true` on a production database is data loss with extra steps.
6. **No client names, account IDs, or internal hostnames.** This repo is
   public. Anything identifying goes in a variable.

## Local checks before opening a PR

Run these and confirm they pass, then paste the results in the PR:

```bash
terraform fmt -check -recursive
terraform validate
```

For any PR touching `.tf` files, also attach the `terraform plan` output as
described above.
