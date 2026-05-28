# commit-skill

> 🧠 An automated commit skill that splits changes into small, focused batches of **Conventional Commits**.

## Overview

`commit-skill` is a skill that guides you through making clean, well-structured git commits. Instead of dumping everything into one big commit, it helps you:

1. **Check changes** — inspect `git status` to see what's modified
2. **Group logically** — stage only files for **one coherent change** at a time (no `git add .`)
3. **Compose message** — write a commit message following the Conventional Commit spec
4. **Validate format** — run `validate.sh` to check the message; fix it if it fails
5. **Commit & repeat** — commit the batch, then loop back for remaining changes

## Directory Structure

```
commit-skill/
├── README.md            # This file
├── skills/
│   ├── SKILL.md         # Skill definition — step-by-step workflow instructions
│   └── validate.sh      # Conventional Commit message format validator
```

## Conventional Commit Format

This skill enforces [Conventional Commits](https://www.conventionalcommits.org/) v1.0.0:

```
<type>(<scope>): <description>
```

| Element | Description |
|---------|-------------|
| **type** | Required. `feat` / `fix` / `docs` / `style` / `refactor` / `perf` / `test` / `build` / `ci` / `chore` / `revert` |
| **scope** | Optional. Lowercase alphanumeric + hyphens, e.g. `(api)` `(deps)` |
| **breaking** | Append `!` before `:`, e.g. `feat(api)!: remove deprecated endpoint` |
| **description** | Lowercase start, no trailing period, imperative mood |
| **body** | Blank line after header, then explain *what* and *why* |
| **footer** | Blank line after body, `Key: Value` format, e.g. `BREAKING CHANGE: ...`, `Closes #12` |

## validate.sh — Message Validator

`skills/validate.sh` is a standalone bash script that performs **comprehensive format checks** on any commit message:

```bash
# Pass
./skills/validate.sh "feat(auth): add login endpoint"

# Fail — capital letter
./skills/validate.sh "Feat(auth): add login endpoint"
# → FAIL: description should not start with a capital letter

# Fail — trailing period
./skills/validate.sh "feat(auth): add login endpoint."
# → FAIL: description should not end with a period
```

### Validation Rules

✔️ Type must be one of the allowed list
✔️ `: ` separator must be present
✔️ Description must not be empty
✔️ Description must start with a lowercase letter
✔️ Description must not end with a period
✔️ A blank line between header and body (if body exists)
✔️ Footer lines must follow `<Key>: <Value>` format

## Installation

```bash
npx skills add git@github.com:Youpen-y/commit-skill.git
```

## Usage

```bash
# Check what's changed
git status --short

# Stage files for a single logical change
git add <file1> <file2>

# Preview the staged diff
git diff --cached

# Validate a commit message
./skills/validate.sh "fix: correct off-by-one error"

# Commit
git commit -m "fix: correct off-by-one error"

# Repeat for remaining changes
```

Or just integrate the workflow described in `skills/SKILL.md` into your editor, CI, or AI assistant.

## Development

```bash
# Test the validator
./skills/validate.sh "fix: correct off-by-one error"

# Run through the full workflow manually
git status --short
git add <some-file>
git diff --cached
./skills/validate.sh "feat: add new feature"
git commit -m "feat: add new feature"
```

## License

MIT
