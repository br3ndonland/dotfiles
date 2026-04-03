# AGENTS.md

## Working agreements

- Use ASCII characters only in all written output, code comments, commit messages, and documentation. Forbidden characters include em/en dashes (— –), curly quotes (“ ” ‘ ’), ellipses (…), or other non-ASCII Unicode. Prefer plain ASCII equivalents at all times.
- Default to pragmatic, concise communication.
- Keep edits minimal and well-scoped; explain changes.
- Prefer local context; use the web only when needed.
- Make safe assumptions; ask only when necessary.
- Avoid destructive actions without explicit approval.
- Do not create Git commits on `main`; always work on a feature branch.
- Do not Git push to `main`; always push to a feature branch.
- Always use the GitHub MCP server for accessing github.com URLs, GitHub repos, GitHub file content, etc. without me having to explicitly ask. Always use the `github_support_docs_search` toolset in the GitHub MCP server to search GitHub documentation. Always use the `git` toolset in the GitHub MCP server for low-level Git operations. Fall back to the GitHub CLI (`gh`) when available. Only use raw fetches if neither MCP nor `gh` can provide the needed content. Always ask before running raw fetches.
- Always use the OpenAI developer docs MCP server if you need to work with the OpenAI API, ChatGPT Apps SDK, Codex, etc. without me having to explicitly ask.
- Always use the Context7 MCP server when you need to work with non-OpenAI or non-GitHub library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.
