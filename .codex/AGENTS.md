# AGENTS.md

## Working agreements

### Output

- Use ASCII characters only in all written output, code comments, commit messages, and documentation. Forbidden characters include em/en dashes (— –), curly quotes (“ ” ‘ ’), ellipses (…), or other non-ASCII Unicode. Prefer plain ASCII equivalents at all times. The only exceptions to this rule are box-drawing characters (├, └, │, ─) in tree diagrams.
- Default to pragmatic, concise communication.
- Keep edits minimal and well-scoped; explain changes.
- Prefer local context; use the web only when needed.
- Make safe assumptions; ask only when necessary.

### Filesystem

- When deleting files or directories, prefer `trash` as a safer default instead of `rm -rf`; use permanent deletion only with explicit user approval.

### Git commits

- Do not create Git commits on `main`; always work on a feature branch.
- Do not Git push to `main`; always push to a feature branch.
- Format Git commit messages in the following style:

  ```text
  Imperative commit title limited to 50 characters

  Begin by describing how the code works now and why a change is needed.
  The commit message body can be detailed. Full paragraphs are acceptable.
  Lines in commit message paragraphs should be limited to 72 characters.

  Summarize changes by saying "This commit will" and using the imperative.

  - The end of the commit message should have a list of references.
  - Add an unordered list item for each URL.
  - Do not hard wrap URLs. URLs can exceed 72 characters if needed.
  ```

### GitHub pull requests

- Always open GitHub pull requests in draft mode.
- Each time a new commit is pushed to a pull request branch, check the pull request title and description and update them if needed to match the current state of the pull request.
- Format GitHub pull request titles and descriptions in the following style:
  - Limit the PR title to around 50 characters so it fits into a squash commit title.
  - Include a concise PR description with these sections:
    - `## Description`: background and context on why the PR is needed. Do not summarize code changes in this section; that will be done in the next section.
    - `## Changes`: summarize changes using the imperative mood. Explain what will change and why. Unordered lists can be helpful here; preface the list in the imperative mood (e.g. "This PR will:"), then state each list item in the imperative mood (e.g. "Fix incorrect styling"). Place terminal output/log snippets in fenced code blocks inside HTML `<details><summary>...</summary> ... </details>` sections.
    - `## Related`: unordered list of links to related resources. Do not link the PR to itself.
  - In the PR description, GitHub autolinked references should be used to refer to issues, PRs, commits, GitHub security advisories, and other supported links. GitHub permanent links to code snippets (permalinks) should be used when referencing code in the same repository as the PR. Permalinks should be on separate lines so they render properly. Non-GitHub URLs should be formatted as Markdown links with descriptive titles (no bare URLs).

### MCP servers

- Always use the GitHub MCP server for accessing github.com URLs, GitHub repos, GitHub file content, etc. without me having to explicitly ask. Always use the `github_support_docs_search` toolset in the GitHub MCP server to search GitHub documentation. Always use the `git` toolset in the GitHub MCP server for low-level Git operations. Fall back to the GitHub CLI (`gh`) when available. Only use raw fetches if neither MCP nor `gh` can provide the needed content. Always ask before running raw fetches.
- Always use the OpenAI developer docs MCP server if you need to work with the OpenAI API, ChatGPT Apps SDK, Codex, etc. without me having to explicitly ask.
- Always use the Context7 MCP server when you need to work with non-OpenAI or non-GitHub library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.

### Python packages

- To install Python packages when there is no project virtual environment, never install them directly with `pip` (e.g. `pip install`, `pip install --user`, `python -m pip install`). Installing packages with `pip` outside of a virtual environment pollutes the system `site-packages` directory. Instead, `uv run --with` is the most ergonomic for throwaway Python scripts. `uvx` is the right choice when the package provides a CLI tool (e.g. `uvx basedpyright`). `pipx run` is a fallback if `uv` is unavailable; it also leaves no persistent state.
