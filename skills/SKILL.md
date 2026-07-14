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

## Workflow

Repeat the following steps until all changes are committed:

### 1. Check current changes

```bash
git status --short
git diff --stat
git diff --cached --stat
```

Review what has changed. If no changes remain, stop.

### 2. Group changes into one logical unit

Based on the diff, identify one coherent, minimal change. Stage **only** the files for that single logical change:

```bash
git add <file1> <file2> ...
```

Do **not** `git add .` or `git add -A`. Stage only the files relevant to this commit.

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
