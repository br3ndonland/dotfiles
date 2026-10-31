# AGENTS.md

## Working agreements

### Output

- Use ASCII characters only in all written output, code comments, commit messages, and documentation. Forbidden characters include em/en dashes (— –), curly quotes (“ ” ‘ ’), ellipses (…), or other non-ASCII Unicode. Prefer plain ASCII equivalents at all times. The only exceptions to this rule are box-drawing characters (├, └, │, ─) in tree diagrams.
- Minimize use of semicolons.
- Default to pragmatic, concise communication.
- Keep edits minimal and well-scoped; explain changes.
- Prefer local context; use the web only when needed.
- Make safe assumptions; ask only when necessary.

### Filesystem

- When deleting files or directories, prefer `trash` as a safer default instead of `rm -rf`; use permanent deletion only with explicit user approval.
- When working with temporary files, do not use `/private`. Use `/tmp` or the directory given by `$TMPDIR` instead.

### Shell commands

- Run commands directly when possible so approval rules can match the executable and its arguments.
- Do not add explicit shell wrappers such as `/bin/zsh -lc`, `zsh -lc`, or equivalents unless the command specifically requires login-shell initialization.
- When shell syntax is necessary, use the execution tool's existing shell instead of starting a nested shell.

### Git worktrees

- Codex-managed worktrees must use the default location `~/.codex/worktrees` and must not be created in `.worktrees`.
- ChatGPT and Codex must use the ChatGPT desktop app Worktree or Handoff controls for task isolation.

### Git commits

- Pushing commits to a feature branch is pre-authorized, including force-pushing after a rebase: push as soon as the commits are committed and validated, without asking for confirmation, and do not ask again for later pushes on the same branch. Use `--force-with-lease` rather than `--force`.
- Unless project-specific authorization has been given, do not create Git commits on `main` or Git push to `main`; always work on a feature branch.
- Apply the following message format only to commits created directly with `git commit`. For GitHub PR squash merges, use the squash merge instructions below.

  ```text
  Imperative commit title limited to 50 characters

  Format commit messages as Markdown.

  Begin by describing how the code works now and why a change is needed.
  The commit message body can be detailed. Full paragraphs are acceptable.

  Reflow prose paragraphs and prose within list items to a maximum of 72
  characters per line. For continuation lines in a list item, indent to align
  with the text after the list marker. Preserve Markdown structure and do not
  reflow code blocks, tables, HTML blocks, headings, or Git trailers.

  Do not hard wrap URLs or Markdown links. A URL or Markdown link may exceed
  72 characters. If a bare URL longer than 72 characters appears in prose,
  place it on its own line. Reference-list items that contain only a URL or
  Markdown link remain one line.

  Summarize changes by saying "This commit will" and using the imperative.

  - The end of the commit message should have a list of references.
  - Add an unordered list item for each URL.
  ```

### GitHub pull requests

- Load the `managing-pull-requests` skill before opening a pull request, pushing to a pull request branch, editing a pull request description, squash merging a pull request, or reporting whether a pull request is reviewed or approved. It defines the title, description, and squash merge format and how to read Codex and Vercel review results.
- Before opening a pull request, load `managing-pull-requests` and follow its cross-model adversarial review procedure, including its finding-resolution and unavailability-waiver rules.

### MCP servers

- Use the GitHub plugin and MCP server for all GitHub operations, including reading code, inspecting checks, and creating or updating issues, pull requests, reviews, and comments. Do not use browser automation for GitHub, switch browser profiles, or initiate browser-based GitHub sign-in. If a required operation is unavailable through the plugin or MCP server, report the specific limitation and ask before using a browser. Do not silently fall back to browser automation. Local Git operations remain permitted within the task's authorized scope.
- Fall back to the GitHub CLI (`gh`) when available. Only use raw fetches if neither MCP nor `gh` can provide the needed content. Always ask before running raw fetches.
- When falling back to `gh` for pull request review threads, use `gh_pr_threads` for `list`, `reply`, `resolve`, and `request-copilot` operations instead of calling `gh api` directly.
- Always use the OpenAI developer docs MCP server if you need to work with the OpenAI API, ChatGPT Apps SDK, Codex, etc. without me having to explicitly ask.
- Always use the Context7 MCP server when you need to work with non-OpenAI or non-GitHub library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.

### Python packages

- To install Python packages when there is no project virtual environment, never install them directly with `pip` (e.g. `pip install`, `pip install --user`, `python -m pip install`). Installing packages with `pip` outside of a virtual environment pollutes the system `site-packages` directory. Instead, `uv run --with` is the most ergonomic for throwaway Python scripts. `uvx` is the right choice when the package provides a CLI tool (e.g. `uvx basedpyright`). `pipx run` is a fallback if `uv` is unavailable; it also leaves no persistent state.

### Presentation slides

- When making slides, omit defensive caveats and generic status captions. Every sentence on a slide must explain its subject or support a specific decision. Do not add phrases such as "proposed architecture", "scope remains open", or "needs separate evidence" merely to qualify a diagram. Include an unresolved issue only when you can name the specific choice and explain how it affects the work. Put it in the relevant discussion or decisions slide. Before adding a qualification, identify the specific misunderstanding it prevents. If the slide makes no claim requiring that qualification, omit it.
