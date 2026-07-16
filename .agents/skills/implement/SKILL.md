---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

## Branch workflow
1. **Create feature branch**: `git checkout -b <type>/<ticket>-<slug> <base-branch>` (default base: `main`)
   - `<type>`: `feat`, `fix`, `chore`, `refactor`, `docs`
   - `<ticket>`: issue/PR number or short identifier
   - `<slug>`: 2-3 word kebab-case summary
2. **Implement on the feature branch** (steps below)
3. **Push & open PR**: `git push -u origin HEAD && gh pr create --fill --base <base-branch>`

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work against the base branch (merge-base).

Commit your work to the feature branch.
