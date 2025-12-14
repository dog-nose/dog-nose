---
description: Create a GitHub PR with intelligent commit analysis from branch commits
argument-hint: [base-branch]
---

Create a GitHub pull request by analyzing the current branch's commits. Follow these steps:

## Step 1: Validation
First, run these validation checks in parallel:
- Check if `gh` CLI is installed: `command -v gh`
- Get the current branch name: `git rev-parse --abbrev-ref HEAD`
- Verify this is a git repository: `git rev-parse --git-dir`

If `gh` is not installed, show an error: "GitHub CLI (gh) is not installed. Install it with: brew install gh"

If the current branch is `main` or `master`, show an error: "Cannot create PR from main/master branch. Switch to a feature branch first."

## Step 2: Determine Base Branch
The base branch should be:
- `$1` if an argument was provided
- Otherwise, default to `main`

## Step 3: Analyze Commits
Run these commands to gather commit information:
- Find the merge base: `git merge-base <base-branch> HEAD`
- Get all commits on this branch: `git log <base-branch>..HEAD --pretty=format:"%s"`
- Get file change statistics: `git diff <base-branch>...HEAD --stat`

If there are no commits (empty log), show an error: "No commits found on this branch compared to <base-branch>."

## Step 4: Check Remote Status
- Check if the current branch is pushed to remote: `git rev-parse --verify origin/$(git rev-parse --abbrev-ref HEAD) 2>/dev/null`
- If not pushed, first push the branch: `git push -u origin <current-branch>`

## Step 5: Generate PR Content

**Title:**
Use the first commit message (first line only) as the PR title.

**Body:**
Create a body with this format:

```markdown
## Summary
- [bullet point from first commit subject]
- [bullet point from second commit subject]
- [etc. for all commits]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Step 6: Create the PR
Execute the `gh pr create` command:
```bash
gh pr create --base <base-branch> --title "<title>" --body "<body-content>"
```

If successful, display the PR URL returned by the `gh` command.

## Error Handling
If any step fails:
- `gh pr create` fails with "already exists": Display the existing PR URL
- Network/API errors: Show the error message from `gh`
- Authentication errors: Prompt user to run `gh auth login`

---

**Important:** Execute all bash commands using the Bash tool. Do NOT use placeholders - use the actual values from the git commands.
