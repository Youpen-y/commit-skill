---
name: commit
description: Commits changes in small, focused batches — one logical change per commit. Use when the user wants to commit changes.
---

# Conventional Commit

## Message Format

```
<type>(<scope>): <description>
```

- **type** (required): `feat` | `fix` | `docs` | `style` | `refactor` | `perf` | `test` | `build` | `ci` | `chore` | `revert`
- **scope** (optional): lowercase alphanumeric + hyphens
- **breaking**: append `!` before `:`, e.g. `feat(api)!: remove old endpoint`
- **description**: lowercase start, no trailing period, imperative mood, use plain common words, keep short
- **body** (optional): blank line separated, explain *what* and *why*
- **footer** (optional): `Key: Value` lines, e.g. `BREAKING CHANGE: ...`, `Closes #12`

## Splitting Principles

One commit = one logical change. When the working tree mixes multiple concerns:

- **Split across files** — stage only the files for one concern.
- **Split within a file** — when a single file mixes concerns, stage individual hunks (Step 2b).
- **Every intermediate commit must build and pass tests.** Never commit a broken state. If a split breaks the build mid-way, fix the boundary or merge the units.
- **Respect dependency order.** If unit B uses code introduced by unit A, commit A first.
- **Don't over-split.** Keep units together when hunks interleave concerns on the same lines, when splitting would need artificial stubs to compile, or when the units are inseparable (e.g., a new API plus its only caller).

## Workflow

Repeat the following steps until all changes are committed:

### 1. Check current changes

```bash
git status --short
git diff --stat
git diff --cached --stat
```

Review what has changed. If no changes remain, stop.

### 2. Identify logical units and dependency order

Read `git diff` (unstaged) and `git diff --cached` (staged). Group changes into coherent units — one per commit — and order them so each builds on what came before (dependencies first). If there is only one unit, go to Step 2b.

### 2a. Stage the unit — file level

If the unit maps cleanly to whole files:

```bash
git add <file1> <file2> ...
```

Do **not** `git add .` or `git add -A`.

### 2b. Stage the unit — within a file (patch staging)

When a file mixes concerns, stage individual hunks. A human would use `git add -p <file>` interactively (`y/n/s/e`); as an agent, build a patch and apply it to the index:

```bash
# 1. Inspect remaining unstaged hunks for the file
git diff -- <file>

# 2. Write a valid unified diff with only THIS unit's hunks
#    (keep the `diff --git` header, --- / +++ lines, and chosen @@ hunks
#     with their context lines) -> /tmp/unit.patch

# 3. Apply those hunks to the index
git apply --cached --recount /tmp/unit.patch

# 4. Confirm what's staged
git diff --cached -- <file>
```

Repeat until all hunks for this unit are staged. Only hunks belonging to this one logical change go in.

### 2c. Verify the intermediate state builds and tests pass

Before committing — especially after a within-file split — confirm the would-be commit is green:

```bash
# Hide unstaged changes; working tree now equals the would-be commit
git stash push --keep-index --include-untracked

# Run build and tests
#   <build> && <test>

# Restore unstaged changes
git stash pop
```

If it fails, the boundary is wrong. Fix it by adding hunks this commit needs (e.g., a function definition it calls), reordering so dependencies land first, or merging the unit with its dependency into one commit. Proceed only once the state is green — or the unit is trivially safe (e.g., docs-only).

### 3. Compose and validate the message

Analyze the staged diff (`git diff --cached`) and compose a commit message. Validate it with `validate.sh`, which lives next to this `SKILL.md`. Run it by the absolute path resolved against the **skill directory**:

```bash
/path/to/skill-dir/validate.sh "<message>"
```

If validation fails, fix the message and re-validate.

### 4. Commit

```bash
# Single-line message
git commit -m "<message>"

# Multi-line message (body / footer)
git commit -F <(printf '%s\n' "<message>")
```

### 5. Confirm and loop

```bash
git log -1 --oneline
```

Then go back to **step 1** to handle remaining changes.
