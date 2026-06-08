---
name: slack-message
description: Compose a Slack message and put it on the clipboard as ready-to-paste rich text using the `slackcopy` tool. Use whenever Andrew asks to write, draft, or reword a Slack message, post, announcement, update, or "give me a message for the team/channel" that he intends to paste into Slack. Writes the message in Markdown, runs it through `slackcopy` so it lands on his clipboard already formatted, and shows the Markdown for review. Applies his Slack style rules (no em-dashes, sparing emphasis, natural human tone). Do NOT use for sending via the Slack MCP/API; this is for messages he pastes himself.
---

# slack-message

Andrew writes Slack messages by composing Markdown, converting it to Slack rich
text on the clipboard with `slackcopy`, and pasting. This skill covers how to
produce those messages so they (a) paste with correct formatting and (b) read
like a person wrote them.

## The delivery step (do this every time)

After composing the message, put it on his clipboard by piping the Markdown to
`slackcopy` over a **quoted** heredoc (the quotes stop the shell from eating
backticks and `$`):

```bash
~/bin/slackcopy <<'EOF'
<the markdown message goes here>
EOF
```

It prints `✓ Slack-formatted rich text copied to clipboard`. Then:

1. Tell him it is on his clipboard, ready to paste into Slack.
2. Also show the Markdown in your reply (in a fenced block) so he can read and tweak it.

`slackcopy` is a local tool at `~/bin/slackcopy` (source: `~/Projects/slackcopy`).
It parses Markdown with a real CommonMark parser and writes `text/html` to the
clipboard, which is what Slack formats on paste. He can also copy Markdown himself
and trigger it with the Raycast "Slackify Clipboard" hotkey.

## Style rules (Andrew's preferences)

These are the point of the skill. Follow them.

- **No em-dashes.** Never use `—`. Restructure instead: use a comma, a colon, a
  period and a new sentence, or parentheses. (Hyphens in compound words and en
  dashes in numeric ranges are fine; the banned character is the em-dash used as
  a sentence connector.)
- **Emphasis is rare.** Real Slack messages are mostly plain text. Heavy bold and
  italics, or bolded "headers", are an easy AI-tell. Default to plain prose. Reach
  for bold or italics only when one specific word genuinely needs it, and rarely.
- **Do not decorate with headings.** A `##` heading becomes a bold line in Slack,
  so a wall of headings reads as over-emphasis. At most one short heading on a
  longer announcement; usually none.
- **Sound like him, not like an assistant.** Skip filler openers and stock phrases
  ("I just wanted to take a moment", "doesn't go unnoticed", "day in and day out",
  "I'm thrilled to"). Be direct and concrete. Short sentences. Specifics over
  superlatives.
- **Emoji:** a few are fine for warm or celebratory messages, none for routine or
  technical ones. Do not pepper every line.
- **Length:** match the ask. Most Slack messages are a few lines. Use a list only
  when there are genuinely distinct items.

## What survives into Slack (so you know what you can use)

`slackcopy` maps these correctly on paste:

| Markdown | Slack result |
| --- | --- |
| `**bold**`, `*italic*`, `~~strike~~` | bold / italic / strikethrough |
| `` `code` ``, fenced ```` ``` ```` blocks | inline code / code block |
| `[text](url)` | link |
| `> quote` | block quote |
| `- item`, `1. item` | bullet / numbered list |
| `## Heading` | a bold line on its own (Slack has no real headings) |

Avoid: tables (Slack does not render HTML tables in messages; use a short list or
a code block instead) and images.

## Gotchas

- Use a **quoted** heredoc (`<<'EOF'`) so backticks, `$`, and `*` are not mangled
  by the shell before `slackcopy` sees them.
- A heading placed directly before a list is handled (the heading stays on its own
  line); other unusual block adjacencies can render oddly, so if he reports a
  layout glitch, treat it as a `slackcopy` bug in `~/Projects/slackcopy`, not a
  reason to change the message.
- Headings render as bold, which counts against the "sparing emphasis" rule. That
  is another reason to prefer plain opening lines over `##` headings.
