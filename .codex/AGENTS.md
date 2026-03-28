# AGENTS.md instructions for ~/.codex

<INSTRUCTIONS>

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

</INSTRUCTIONS>

## Description for humans

This file provides [persistent user instructions for Codex](https://developers.openai.com/codex/guides/agents-md). Codex recognizes the H1 heading at the top of the file and uses special markers to indicate a [user instructions fragment](https://github.com/openai/codex/blob/61dfe0b86c75bb4e6c173a70ca9fb2f2daac2f67/codex-rs/instructions/src/fragment.rs). Codex then [serializes the user instructions fragment](https://github.com/openai/codex/blob/178d2b00b1da55e24a16695337bb1b78d6f5883c/codex-rs/instructions/src/user_instructions.rs#L19-L35) and adds it to context. Text after the end marker (like this) is excluded from context. [Tests](https://github.com/openai/codex/blob/178d2b00b1da55e24a16695337bb1b78d6f5883c/codex-rs/instructions/src/user_instructions_tests.rs) demonstrate this behavior.

Notes on specific working agreements:

- The working agreement for GitHub is based on [their README](https://github.com/github/github-mcp-server).
- The working agreement for OpenAI developer docs is based on [their docs](https://developers.openai.com/learn/docs-mcp).
- The working agreement for Context7 is based on [their docs](https://context7.com/docs/tips).
