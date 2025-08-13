---
description: Smart git push with proper workflow (status, diff, add, commit, push)
argument-hint: [commit message]
---

I'll perform a complete git workflow: check status, review changes, stage files, commit with a proper message, and push to remote.

First, let me check the current git status and see what changes need to be committed:

```bash
git status
```

Let me also see the actual changes:

```bash
git diff
git diff --cached
```

Now I'll stage the changes:

```bash
git add .
```

Let me create a proper commit message following conventional commits format. If you provided a message as an argument, I'll use that. Otherwise, I'll analyze the changes and create an appropriate message:

$ARGUMENTS

Finally, I'll push the changes:

```bash
git push
```

If this is the first push to a new branch, I'll use:

```bash
git push -u origin $(git branch --show-current)
```