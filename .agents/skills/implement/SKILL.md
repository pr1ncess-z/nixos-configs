---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

## Resolve the work unit

Before branching, decide what the unit of work actually is. A spec (parent issue) is the contract; its sub-issues are the work.

1. **Check for sub-issues** on the issue the user gave: GraphQL `subIssues(first: 50)` on the issue node.
2. **If the issue has `ready-for-agent` sub-issues**, implement those — one sub-issue per branch/PR — not the monolithic spec. The spec is the source of truth for *what* to build; the sub-issue is the ticket that scopes *how much* to build in one PR. Pick the first sub-issue that is unblocked and `ready-for-agent`.
3. **If it has none**, the issue itself is the work unit — implement it directly.

A spec with many user stories is a parent, not a ticket. Never try to implement a whole spec in one branch.

## Branch workflow
1. **Create feature branch**: `git checkout -b <type>/<ticket>-<slug> <base-branch>` (default base: `main`) — `<ticket>` is the sub-issue number when working from a spec.
   - `<type>`: `feat`, `fix`, `chore`, `refactor`, `docs`
   - `<ticket>`: issue/PR number or short identifier
   - `<slug>`: 2-3 word kebab-case summary
2. **Implement on the feature branch** (steps below)
3. **Push & open PR**: `git push -u origin HEAD && gh pr create --fill --base <base-branch>`

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work against the base branch (merge-base).

Commit your work to the feature branch.
