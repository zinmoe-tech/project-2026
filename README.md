# Simple Project

This is a minimal demo project to get started with GitHub Actions. It contains a single static page (`index.html`) and a tiny workflow that checks the file on push or pull request.

How to use locally

- Initialize git and commit the files:

```bash
git init
git add .
git commit -m "chore: initial minimal project"
```

- To push to GitHub, add your remote and push a branch or `main`:

```bash
git remote add origin https://github.com/<your-user>/<your-repo>.git
git branch -M main
git push -u origin main
```

What the workflow does

- Runs on `push` and `pull_request`.
- Checks out the repository and verifies `index.html` contains the text `Hi`.

Next steps

- If you'd like, I can initialize the git repo here for you and push a branch (you'll need to confirm the remote and credentials), or you can push from your machine.

Trigger Build-and-Deploy: 2026-04-17T11:19:35Z
