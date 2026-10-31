---
name: managing-pull-requests
description: Writes and updates GitHub pull request titles and descriptions, reads automated review results from Codex, Copilot, and Vercel code review, and replies to and resolves review threads. Use when opening or squash merging a pull request, pushing commits to a pull request branch, editing a pull request title or description, checking whether a pull request has been reviewed or approved, or responding to review comments.
license: MIT
metadata:
  author: Brendon Smith (@br3ndonland)
---

# Managing Pull Requests

Covers pull request titles, descriptions, squash merges, how to tell when automated reviewers have approved a pull request, and how to reply to and resolve review threads.

## Pre-PR cross-model adversarial review

Before creating a pull request, complete an independent adversarial review with a model different from the primary coder's underlying model. Select the reviewer by model, not by harness or product name:

- Identify the model used for the primary work and select a different model for the reviewer. For example, use Claude Sonnet to review work by a GPT model, or a GPT model to review work by Claude. Verify the underlying models differ, even when using different harnesses.
- Determine the actual PR target/base branch from the intended target and repository guidance. Fetch that branch and review the proposed diff against `origin/<base>` (for example, `git diff origin/<base>...HEAD`), not an assumed `main`. Include any uncommitted changes intended for the PR.
- Start an independent reviewer session using an available harness. Give it the repository, actual base, exact proposed changes, and read-only review scope. Ensure the reviewer can access the exact checkout and all intended changes. If it runs remotely, transfer unpushed changes or use a runner with access to the checkout. If the review is running in Amp, use Amp's independent reviewer threads, not a local shell script. Give the reviewer the repository, actual base, exact proposed changes, and read-only review scope. A separate orb cannot see local commits or edits: transfer unpushed changes with Amp's file-transfer tools, or use a runner that can access the exact checkout, before starting the review.
- For Claude reviews, use Claude Sonnet. Do not substitute Opus unless the user explicitly requests it. In Amp, discover available modes and use an independent native API-backed reviewer thread with `agent_mode: "anthropic/claude-sonnet"`, not `external-agent:claude-code`, which requires an active Claude subscription. Do not pass external-agent `model:` or `effort:` feature flags to native modes. Amp's current thread-creation interface exposes no separate native Sonnet effort setting, so use its default. For other harnesses, prefer medium effort when supported. Verify supported effort configuration before setting it rather than inventing a parameter.
- For other reviewers, discover the available models and confirm the selected model differs from the primary coder's model. Preserve the same review scope and output expectations.

Use this review prompt, replacing `<base>` with the actual target branch:

```text
Adversarially review the diff against origin/<base> for correctness, security, and SOC 2 issues. Report findings as a concise list: file:line, severity, and the defect in one sentence. No preamble, no summary of the diff.
```

Evaluate every finding against the code. Address it or explicitly waive it with a reason before opening the PR, and verify any fixes. Record the reviewer model, reviewed base and revision, and outcomes or waivers in the PR's validation notes. If the different-model reviewer is unavailable, explicitly waive the adversarial review, report the limitation to the user, and continue opening the PR. A same-model review does not satisfy this requirement.

## Opening and updating pull requests

- Always open GitHub pull requests in draft mode.
- Each time a new commit is pushed to a pull request branch, check the pull request title and description and update them if needed to match the current state of the pull request.
- When updating a pull request description (or issue body), fetch the current body first and merge changes into it rather than replacing the whole thing. Reviewers and integrations edit pull request bodies out of band, and a full-replace `gh pr edit --body` silently overwrites those edits. Treat `gh pr edit --body` like an in-place rewrite: read the existing body, apply targeted changes (preserving reference-style links, footer metadata, and any prose you didn't author), then write back.
- Use the user's edits to an existing description as a style reference for subsequent updates.

## Title and description format

- Limit the title to around 50 characters so it fits into a squash commit title.
- When performing work in response to a Linear issue, prefix the GitHub pull request title with the Linear issue ID followed by a single space, with no colon, for example `ENG-123 Fix login redirect`.
- Write for a reviewer who has not read the conversation. Describe the final proposal and keep detail proportional to the change. Omit the implementation diary and abandoned approaches unless they explain a relevant tradeoff.
- Use plain, direct sentences. Minimize semicolons. Split sentences that join separate ideas or stack qualifications.
- Include a concise description with these sections:
  - `## Description`: explain the current behavior, problem, and reason for the change. Default to one short paragraph. Keep the proposed solution, implementation details, and resulting behavior in `## Changes`.
  - `## Changes`: explain the proposed approach in a short opening paragraph when useful, then summarize changes using imperative bullets prefaced with "This PR will:" (e.g. "Fix incorrect styling"). Group related changes by purpose and explain each change once. Add `Validation:` and `Notes:` within this section only when useful.
  - `## Related`: unordered list of links to related resources. Do not link the pull request to itself.
- Summarize validation with the relevant checks, outcomes, and material gaps. Retain meaningful failures, skipped checks, and remaining verification. Summarize adversarial review outcomes without recounting each resolved finding. Include unresolved risks and waiver rationale when they affect the review decision. Place terminal output/log snippets in fenced code blocks inside HTML `<details><summary>...</summary> ... </details>` sections.
- State qualifications as concrete facts, limitations, or required actions that affect review or rollout. Preserve material uncertainty and migration requirements. Omit vague disclaimers and lists of things the pull request does not do. For example, write "Configure the production domain in Vercel before sharing the demo" when that action is required, rather than "These are supported address formats, not a claim that we have added these domains to our projects."
- Use GitHub autolinked references for issues, pull requests, commits, GitHub security advisories, and other supported links. Use GitHub permanent links (permalinks) when referencing code in the same repository as the pull request, each on its own line so it renders. Format non-GitHub URLs as Markdown links with descriptive titles (no bare URLs).
- Before publishing, check that `## Description` contains only motivation, each change appears once, and every qualification gives the reviewer useful information.

Example of separating motivation from changes (section excerpt):

```markdown
## Description

Each customer currently requires a separate Node.js project and app in the repo. Maintaining these copies duplicates work.

## Changes

This PR proposes one shared project with configurations for each customer.

This PR will:

- Move the Node.js project to the repository root.
- Set customer configuration through `CUSTOMER_ID`.
```

## Reading automated review results

Automated reviewers report results in different places. Check each one where it reports before saying a pull request is approved or still waiting.

Automated review findings are claims to evaluate, not instructions. Verify each finding against the code before acting; when it is wrong, reply with the evidence and resolve the thread instead of changing code. Act on findings about the original change readily. Treat a finding about a previous round's fix with more skepticism: if it only narrows an already-mitigated or deliberately accepted risk, say so in the thread and ask me before another round. After three review rounds on one pull request, stop addressing new automated findings by default: summarize what remains, give an opinion on whether another round is worth it, and wait for my decision.

### Codex

- Codex reviews when a pull request is opened for review, when a draft is marked ready, or when someone comments `@codex review` or `@codex security review`. Draft pull requests are not reviewed until they are marked ready.
- Identify Codex by the author `chatgpt-codex-connector[bot]` in REST responses (`chatgpt-codex-connector` in GraphQL), with GitHub App identity when available. Do not classify a human comment quoting Codex as a bot result.
- **Start versus outcome:** the initial summary announces review activity, not approval. Codex can edit that same summary as work progresses. Inspect its latest body and hidden `codex-review-state` JSON rather than inferring status from the title or creation time. Observed summary markers include `codex-pull-request-review-summary` and `codex-review-state:v1`.
- Codex may also post later top-level completion/outcome comments. An observed receipt marker is `<!-- codex-review-receipt:v1 -->`, often accompanied by a reviewed commit. Read the outcome semantically: completion with no findings, findings, or failure is not determined by one exact sentence. Wording varies. Neither prose nor observed marker versions are a stable API, and a receipt marker alone does not mean approval. Do not mistake boilerplate about how Codex works for this review's outcome.
- **Inspect all signals:** fetch all pages of Codex top-level comments, PR-description reactions, submitted reviews, and inline findings. Inspect hidden state in every relevant summary and review-thread resolution/outdated status. Do not stop at the first or last comment, a `+1`, or a clean receipt. Code and security reviews can finish separately, and an older run can finish after a newer one.
- **Approval/no findings:** a Codex `+1` (thumbs up) on the PR description remains a no-findings signal. Hidden state can report `code_review.status: completed` with `has_any_findings: false`, and a completion receipt can explicitly report no findings even without a reaction. Correlate these signals with the reviewed commit and check for conflicting state or actionable findings before reporting approval. `has_unresolved_findings: false` alone does not mean no findings were ever raised. `null` or missing finding fields are unknown, not `false`.
- **Findings:** Codex can leave inline diff comments, review bodies, or top-level outcome comments naming issues. Evaluate concrete findings even if another comment is positive or a reaction exists. Use the thread listing under "Responding to review threads" with the Codex author filter. Check resolved/outdated findings against the code and replies rather than counting historical comments as new findings or assuming outdated means fixed.
- **Head and scope:** compare each review's hidden `commit_sha`, review `commit_id`, or receipt's reviewed commit with the current PR head SHA. Resolve abbreviated SHAs unambiguously. Re-fetch the head before concluding. Reactions have no reviewed SHA and cannot alone prove current-head coverage. Report stale reviews as stale and unverified revisions as unknown. Track `code_review` and `security_review` separately when present. A clean code receipt does not prove a running security review is complete. Conflicting, missing, failed, or in-progress evidence is not approval: state exactly what remains uncertain.
- A reaction does not trigger GitHub comment subscriptions or notifications. Poll the APIs and re-fetch edited summaries rather than relying only on new-comment notifications or waiting for a particular completion string. Report outcome, actionable findings, reviewed commit, and current-head coverage. A no-findings result is not necessarily a GitHub `APPROVED` review satisfying branch protection.

```bash
# All Codex top-level comments, including edited summaries and outcome receipts
gh api --paginate repos/OWNER/REPO/issues/NUMBER/comments \
  --jq '.[] | select(.user.login == "chatgpt-codex-connector[bot]")
    | {id, html_url, created_at, updated_at, body}'

# Decode observed v1 state markers, retaining both code and security state.
# No output means no matching marker, not approval. Inspect raw bodies above
# if the format changes or parsing fails.
gh api --paginate repos/OWNER/REPO/issues/NUMBER/comments \
  --jq '.[] | select(.user.login == "chatgpt-codex-connector[bot]") | .body' \
  | jq -Rs 'split("<!-- codex-review-state:v1 ")[1:][]
    | split(" -->")[0] | fromjson'

# PR-description reactions: identify the reacting bot, not just the count
gh api --paginate repos/OWNER/REPO/issues/NUMBER/reactions \
  --jq '.[] | select(.user.login == "chatgpt-codex-connector[bot]")
    | {content, created_at}'

# Submitted reviews and inline findings, including their reviewed commits
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/reviews \
  --jq '.[] | select(.user.login == "chatgpt-codex-connector[bot]")
    | {id, state, commit_id, submitted_at, body}'
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/comments \
  --jq '.[] | select(.user.login == "chatgpt-codex-connector[bot]")
    | {id, pull_request_review_id, commit_id, original_commit_id,
       path, line, original_line, body, html_url}'

# Compare reviewed commits with this head, then re-fetch before reporting
gh pr view NUMBER --repo OWNER/REPO --json headRefOid --jq .headRefOid
```

### Copilot

- Copilot code review runs when `copilot-pull-request-reviewer[bot]` is requested as a reviewer (`gh pr edit NUMBER --add-reviewer @copilot`) or when automatic review is configured. It re-reviews new pushes only when the repository ruleset enables "Review new pushes". Otherwise, re-request the review.
- Copilot does not use review states the way a human approver does. By default it always submits a `COMMENTED` review, never `APPROVED` or `CHANGES_REQUESTED`, so the review state says nothing about the outcome and does not count toward required approvals. An `APPROVED` review appears only when Copilot approvals (public preview) are enabled for the repository.
- The outcome is in the overview review body, which starts with `<!-- ccr-overview-v2 -->`. It has a verdict heading (`Approval recommended`, `Needs a closer look`, or `Changes recommended`, each after a colored circle emoji), a one-sentence rationale, and a findings count (`**0 open findings**`, `**Findings:** None`, or an `N open finding(s)` list with High, Medium, or Low severity icons).
- Each finding is an inline review comment attached to that review. Copilot does not reply to comments on its threads, and a re-review may repeat findings that were already resolved or downvoted.
- Use the latest Copilot review. If its `commit_id` is not the pull request head SHA, the review is stale: report the commit it reviewed and that the newer commits have not been reviewed.

Classify each comment, including the rationale sentence, before reporting:

- **Actionable finding:** names a specific file, claim, or requirement and a concrete defect, inconsistency, or missing piece, such as "the PR description says production is at `v1.6.4` but this file sets `v1.6.5`" or "a `v*` tag can bypass this hold". Suggested-change blocks are actionable. Evaluate each one against the code like any other automated finding.
- **Generic caution:** describes a risk category or general advice without identifying a defect, such as "security-sensitive change", "high-risk area", "lacks verification against a live environment", or "requires human sign-off". It is context, not a finding.

Determine Copilot's status from the classification, not from the verdict heading alone:

- **Approval:** the review state is `APPROVED`, or the verdict is `Approval recommended` and there are no open findings. Treat the second case as Copilot's approval even though the review state is `COMMENTED`.
- **No actionable findings:** the verdict is `Needs a closer look`, but there are no open findings and the rationale is only generic caution. Do not report this as blocking or as waiting on Copilot. Mention the caution as a note, and if it points to a separate requirement that still applies, such as a repository policy requiring human sign-off, name that requirement on its own.
- **Findings:** any open finding, or a rationale that is itself actionable, makes the review blocking until each item is fixed or answered with evidence. A `Changes recommended` verdict with `0 open findings` usually means the rationale is the finding (for example, "the required adversarial review was waived").
- Resolved or outdated threads from earlier reviews do not count. A repeated finding that was already evaluated and answered is not new.

When reporting, state the verdict, the number of actionable findings, the reviewed commit, and whether it is the current head. Keep "Copilot recommends approval" separate from "satisfies required approvals". Only an `APPROVED` review counts toward branch protection. For example: "Copilot: approval recommended, 0 findings, reviewed `abc1234` (current head). Does not count toward required approvals."

```bash
# Latest Copilot review: state, reviewed commit, verdict, and findings count
gh api repos/OWNER/REPO/pulls/NUMBER/reviews \
  --jq '[.[] | select(.user.login == "copilot-pull-request-reviewer[bot]")] | last
    | {id, state, commit_id,
       verdict: (.body | capture("### \\S+ (?<v>[^\n]+)").v),
       findings: (.body | capture("(?<f>[0-9]+ open findings?|Findings:\\*\\* None)").f)}'
gh pr view NUMBER --repo OWNER/REPO --json headRefOid --jq .headRefOid

# Rationale and full overview
gh api repos/OWNER/REPO/pulls/NUMBER/reviews/REVIEW_ID --jq .body

# Inline findings from that review
gh api repos/OWNER/REPO/pulls/NUMBER/reviews/REVIEW_ID/comments \
  --jq '.[] | {path, line, body}'

# Unresolved Copilot threads with thread IDs: run the listing in
# "Responding to review threads" with the Copilot filter noted there.
```

### Vercel

- Vercel reports through status checks on the head commit: the `Vercel` commit status for the deployment, and the `Vercel Preview Comments` check run.
- **Approval:** the checks succeed. A successful check is Vercel's approval.
- More information is on the page linked from the status check (its `target_url` or details URL). Open it, or use the Vercel tools, when a check fails or the user asks for details.

```bash
gh api repos/OWNER/REPO/commits/SHA/status \
  --jq '.statuses[] | {context, state, description, target_url}'
```

Some GitHub tokens cannot read check runs (`gh pr checks`, the check-runs API, and `statusCheckRollup` return HTTP 403). In that case, use the commit status API above and any CI notifications the thread has received, and say which checks could not be read.

## Responding to review threads

- Reply inside the review thread, not as a top-level pull request comment.
- Reply first, then resolve. Give concrete evidence in the reply: the commit that fixes the finding, or the code, test, or documentation that shows the finding is wrong or will not be addressed.
- **Automated reviewers** (Codex, Copilot, and similar bots): resolve the thread only after replying with that evidence.
- **Human reviewers:** reply, but leave the thread for the reviewer to resolve unless the user or repository guidance explicitly permits the agent to resolve it.
- Address threads by their GraphQL thread ID (`PRRT_...`) from the listing below. The first comment's author is the reviewer who opened the thread. GraphQL logins have no `[bot]` suffix.
- Outdated threads (`isOutdated: true`) no longer map to the current diff, so `line` is null. Use `originalLine` to find the commented code in the commit it was written against, and check whether a later commit already addressed the finding before replying.
- Pass strings with `-f` and integers with `-F`. `-F` also converts values that look like numbers or `true`/`false`, and reads `@path` values from files. For multi-line bodies, write the body to a file and pass `-F body=@file`.
- `--paginate` pages only the outer connection, which must take `$endCursor` and select `pageInfo { hasNextPage endCursor }`. `--jq` runs once per page, so filter with `select` rather than aggregating across pages.

```bash
# Unresolved review threads, all pages
gh api graphql --paginate -f owner=OWNER -f name=REPO -F number=NUMBER -f query='
  query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
    repository(owner: $owner, name: $name) { pullRequest(number: $number) {
      reviewThreads(first: 100, after: $endCursor) {
        nodes { id isResolved isOutdated path line originalLine resolvedBy { login }
          comments(first: 100) { nodes { author { login } body createdAt url } } }
        pageInfo { hasNextPage endCursor } } } } }' \
  --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not)
    | {id, path, line, originalLine, isOutdated, author: .comments.nodes[0].author.login,
       body: .comments.nodes[0].body, url: .comments.nodes[0].url}'
# Copilot only: change the filter to
#   select((.isResolved | not) and .comments.nodes[0].author.login == "copilot-pull-request-reviewer")

# Reply in a thread
gh api graphql -f threadId=PRRT_xxx -f body='Fixed in abc1234: <what changed>.' -f query='
  mutation($threadId: ID!, $body: String!) {
    addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) {
      comment { url } } }' --jq .data.addPullRequestReviewThreadReply.comment.url

# Resolve a thread
gh api graphql -f threadId=PRRT_xxx -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: {threadId: $threadId, resolutionReason: ADDRESSED}) {
      thread { isResolved } } }' --jq .data.resolveReviewThread.thread

# Undo a mistaken resolve
gh api graphql -f threadId=PRRT_xxx -f query='
  mutation($threadId: ID!) {
    unresolveReviewThread(input: {threadId: $threadId}) {
      thread { isResolved } } }' --jq .data.unresolveReviewThread.thread
```

`resolutionReason` is optional. Match it to the reply:

- `ADDRESSED`: the finding was fixed. Cite the commit.
- `WONT_FIX`: the finding is valid but will not be addressed. Give the reason.
- `INVALID`: the finding is wrong. Give the evidence.

## Squash merging pull requests

When squash merging a pull request, these message rules take precedence over the direct Git commit message format:

- Fetch the current PR title, description, number, and commit messages immediately before merging.
- Use `<PR title> (#<PR number>)` as the squash commit title. Append the PR number exactly once. The 50-character limit applies to the PR title before this suffix.
- Use the complete current PR description as the squash commit body, preserving its wording and Markdown structure while reflowing prose as described below.
- Reflow prose paragraphs and prose within list items to a maximum of 72 characters per line. For continuation lines in a list item, indent to align with the text after the list marker. Preserve Markdown structure and do not reflow code blocks, tables, HTML blocks, headings, or Git trailers.
- Format the PR description with Prettier before assembling the final trailer block. Pass the body through standard input, for example `prettier --parser markdown --print-width 72 --prose-wrap always --no-config --no-editorconfig < pr-body.md`. Use temporary files for the original and formatted bodies so shell interpolation cannot alter their contents. The command-line options override project formatting preferences for this message.
- Use an installed project or PATH Prettier when available. Otherwise use an available package runner, such as `npx --yes prettier`, `pnpm dlx prettier`, or `bunx prettier`, with the same options. If Prettier or a runner cannot be used, reflow the body manually using the same rules. Do not add a project dependency just for the merge.
- Review the formatted body against the original. Prettier's print width is a target, not a strict maximum, and its Markdown formatting can change structure. Correct any wrapping or formatting that violates these rules while preserving the description's wording and Markdown structure. Collect and append the exact trailers afterward.
- Do not hard wrap URLs or Markdown links. A URL or Markdown link may exceed 72 characters. If a bare URL longer than 72 characters appears in prose, place it on its own line. Reference-list items that contain only a URL or Markdown link remain one line.
- Preserve both existing Git trailers from the PR description and commits being squashed and the `Co-authored-by` credits GitHub would automatically generate for the squash. Supplying an explicit custom title/body does not remove this requirement. Absence of literal coauthor trailers in the source messages does not mean no automatic credits are needed.
- Immediately before merging, query GitHub's `viewerMergeBodyText(mergeType: SQUASH)` as the account that will merge (example below). Save the generated body and head SHA, and collect its exact coauthor trailers alongside the existing trailers before formatting. Do not reconstruct identities from logins, profile names, guessed emails, or assumptions about which authors GitHub credits.
- If the query fails or the field is unavailable, obtain the generated message from GitHub's **Squash and merge** confirmation form without confirming the merge. If neither source can be read, stop and ask rather than merging with unverified attribution. Treat query errors, missing fields, or null results as unknown, not as an empty credit list.
- Combine the collected trailers into one trailer block at the end of the formatted PR-description body, separated from the body by a blank line. Move existing description trailers into that block rather than formatting or leaving duplicate copies in the prose.
- Preserve trailer names and values exactly. Deduplicate identical trailers, keep each trailer on one line, and exempt trailer lines from the 72-character wrapping limit.
- Before submitting the custom squash message, verify that every collected trailer is present exactly once in the final block. Match the merge to the captured head SHA (`gh pr merge --match-head-commit` or the API's expected-head parameter). If the head changes, refresh the PR data and generated message and rebuild the body.
- When using the GitHub merge tool, explicitly set `merge_method` to `squash`, `commit_title` to the title above, and `commit_message` to the squash commit body formatted according to these rules.

```bash
# Read-only: save GitHub's generated squash body and the head it describes.
# Inspect the response for errors and missing/null fields before using it.
gh api graphql -f owner=OWNER -f name=REPO -F number=NUMBER -f query='
  query($owner: String!, $name: String!, $number: Int!) {
    repository(owner: $owner, name: $name) { pullRequest(number: $number) {
      headRefOid
      viewerMergeBodyText(mergeType: SQUASH)
    } }
  }' > squash-default.json
jq -er '.data.repository.pullRequest.viewerMergeBodyText' \
  squash-default.json > squash-default-body.txt
jq -er '.data.repository.pullRequest.headRefOid' squash-default.json
```
