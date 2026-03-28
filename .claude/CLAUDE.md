# CLAUDE.md instructions for ~/.claude

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
- Always use Context7 MCP when you need to work with non-OpenAI library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.

<!-- maintainer notes

This file provides persistent user instructions for Claude Code.
Claude Code will exclude HTML comments from context.
It is unclear if the "maintainer notes" text is needed in the comments.
The [Claude Code docs](https://code.claude.com/docs/en/memory) suggest HTML comments with "maintainer notes", but
the [Claude Code changelog](https://code.claude.com/docs/en/changelog#2-1-72) says any HTML comments are excluded
([anthropics/claude-code#32688](https://github.com/anthropics/claude-code/issues/32688)). There don't seem to be
any tests in the Claude Code GitHub repo to demonstrate this behavior.

-->
