# AGENTS.md instructions for OpenCode

- Default to pragmatic, concise communication.
- Keep edits minimal and well-scoped; explain changes.
- Prefer local context; use the web only when needed.
- Make safe assumptions; ask only when necessary.
- Avoid destructive actions without explicit approval.
- Do not create Git commits on `main`; always work on a feature branch.
- Do not Git push to `main`; always push to a feature branch.
- For all github.com URLs, use the GitHub MCP server when available; fall back to `gh` when available. Only use raw fetches if neither MCP nor `gh` can provide the needed content. Always ask before running raw fetches.
- Prefer `gh` over `git` for GitHub operations when available; this avoids protocol mistakes (e.g., HTTPS clone on SSH-configured devices).
