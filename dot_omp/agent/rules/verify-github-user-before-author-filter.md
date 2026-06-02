---
name: verify-github-user-before-author-filter
description: "Do not filter PRs by an author name taken from the OS username without verification"
condition: "author=[^&\\s]+"
scope: "tool:read(pr://*)"
---

Do not assume the OS username matches the GitHub username. Before filtering PRs by author, verify the correct GitHub handle via `git config user.name` or `git config github.user`. If the search returns no results, immediately re-search without the author filter and present all open PRs. Never treat 'no results from author filter' as 'no PRs exist'.