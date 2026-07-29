# terraform_treasures

Reusable Terraform modules and patterns for common AWS infrastructure.

## Status: this repo is mid-remediation

It began as client infrastructure code committed as-is, and it still carries
that shape. Read `docs/remediation.md` before adding anything. In particular,
**do not copy the existing patterns**: several of them are the things being
fixed.

## The rule that governs everything

**The diff is not the change. The plan is the change.**

A one-line edit can destroy a database. No Terraform change is reviewed, and
none is applied, without `terraform plan` output attached to it.

## Hard gates

Freely: `fmt`, `validate`, `plan`, `state list`, `state show`, `output`.

**Explicit per-operation approval, on the specific plan output:**
`apply`, `destroy`, `import`, `taint`, `force-unlock`, `state rm`, `state mv`.

A `state` operation bypasses review and cannot be replayed. If one seems
necessary, say why and stop.

## Non-negotiables

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

## Structure

See `references/repo-structure.md` in the workspace harness. Target layout:

```
modules/<name>/     main.tf variables.tf outputs.tf versions.tf README.md
environments/<env>/ composition, backend config, tfvars.example
examples/<name>/    runnable, minimal, tested in CI
```

Every module needs a README with inputs, outputs, and a runnable example.
`examples/` is the most-read directory in a Terraform repo and usually the
least maintained. It is tested in CI or it is a lie.

## Review

Any change touching `.tf` goes to the `terraform-reviewer` subagent, which
reads the plan rather than the diff and ranks findings by irreversibility.

## Workflow

All tracked work follows `skills/dev-pipeline` in the workspace harness:
select, audit, plan, claim, build, test, validate, push, PR, verify, review,
merge. Terraform adds one gate: **the plan is posted on the PR and the approval
is of that specific plan**, not of the diff.
