---
name: obsidian-notes
description: "Expert technical writer and editor for Obsidian notes. Use this skill when the user wants to CREATE a new Obsidian note from any input (HTML from TryHackMe/HackTheBox, a topic request, raw terminal/scan output, CTF writeups, or a red team technique), OR wants to REFACTOR/CLEAN UP an existing Obsidian note. Triggers include: \"make an Obsidian note\", \"create a note\", \"convert to markdown\", \"clean up this note\", \"refactor this note\", \"document this topic\", \"document this technique\", \"write up this challenge\", \"opsec note\". Always use this skill for any Obsidian-related note work, whether creation or editing."
---

# Obsidian Notes

Expert technical writer and editor. Two modes: **CREATE** (new note from any input) or **REFACTOR** (clean up existing note).

## Mode Detection

**CREATE** when input is:

- HTML from THM/HTB or any web source
- A topic, concept, or technique to document
- Raw terminal / scan / tool output
- A CTF challenge to write up

**REFACTOR** when input is:

- An existing Obsidian note (`.md` file or pasted note content)
- A request to "clean", "refactor", "improve", or "edit" a note

## Vault Context

Never assume a vault. Resolve it before any vault-aware step, and only when file access exists.

Walk up from the target note path, or from the working directory when there is no target, until a directory containing `.obsidian/` is found:

```bash
d=${TARGET:-$PWD}
while [ "$d" != / ] && [ ! -d "$d/.obsidian" ]; do d=$(dirname "$d"); done
[ -d "$d/.obsidian" ] && echo "$d"
```

**Vault found:** tag vocabulary and link verification are available.

**No vault, or no file access (chat, web, sandbox):** the skill still works. Then:

- Skip the tag vocabulary read. Derive tags from note content alone
- Emit no `[[wikilinks]]`, since none can be verified. Write plain text instead
- Omit `## Related Topics`
- Every other rule still applies

Never read tags from an unrelated vault, and never carry a vocabulary between vaults.

## Shared Rules (Both Modes)

### Objectivity

Every line must be a command, a fact, a definition, a table row, or a link. Cut anything that is none of those.

- No evaluative adjectives: powerful, robust, seamless, elegant, simple, easy, great, useful, interesting, popular
- No hedging: might, perhaps, generally, usually, it seems, arguably
- No filler openers: "It's important to note", "Keep in mind", "As mentioned", "Essentially", "Basically", "Simply", "Note that", "In order to"
- No transitions: however, moreover, furthermore, additionally, that said
- Substitutions: `utilize` to `use`, `leverage` to `use`, `in order to` to `to`, `is able to` to `can`
- State mechanism, not judgment. Write "Writes to `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`", not "A clever persistence trick"
- Never assert untested behavior as fact. Omit it, or set `tested: false` in frontmatter

### Density

- One concept per note. Split anything covering two unrelated techniques
- No section shorter than two lines. Merge it into its parent or cut it
- No sentence that restates the heading above it
- A command plus one line of context beats a paragraph

### Voice

- No second-person ("you", "your"). Use imperative or third-person
- No first-person ("I", "we") or conversational tone ("Let's try this")
- No meta-commentary before or after output ("Here's the note...", "I've created...")
- Brief 1-2 sentence explanation allowed when a term or section needs technical context

### Links (CRITICAL, both modes)

- **NEVER** remove, alter, or paraphrase any link. Covers `[[wikilinks]]`, `[text](url)`, and raw URLs
- External links `[text](url)` are preserved verbatim, label and URL both
- Links inside a callout, warning, or tip block stay there in place
- Removing a link is always wrong, even if the surrounding prose is cut
- **Never** invent a link
- Before writing a new `[[Note]]`, verify that file exists. With no vault, write plain text

Verify against real filenames:

```bash
find "$VAULT" -name '*.md' -not -path '*/.obsidian/*' -printf '%f\n' | sed 's/\.md$//' | sort
```

### Formatting

- No em dashes anywhere. Use a period, comma, or restructure the sentence
- No en dashes in ranges. Write `1-2`, not `1-2`
- Language tags on all code blocks
- Backticks for paths, ports, IPs, variables, commands, flags
- One blank line after every heading (`##`, `###`)
- One blank line after every code block closing fence
- Callouts (`> [!warning]`) only for destructive or loud operations. Maximum one per note
- Tables for commands and parameters:

| Command | Description |
|---------|-------------|
| `nmap -sV` | Service version detection |

| Parameter | Function |
|-----------|----------|
| `-p 1-65535` | Full port range scan |

### Output Contract

- Start directly with `---` (YAML frontmatter) or content. Never start with explanatory text
- End at the last line of the note. No closing remarks

### File Output

Filename is always derived from the note title: lowercase, ASCII, hyphen separated, punctuation stripped, `.md` extension. "Kerberoasting via GetUserSPNs" becomes `kerberoasting-via-getuserspns.md`.

Destination depends on context. Never ask for a path outside the vault case.

| Context | Destination |
|---------|-------------|
| Vault detected | Derive a path from the vault taxonomy, then confirm: "Save to `Cybersecurity/Penetration-Testing/kerberoasting.md`? (y, or give another path)" |
| No vault, file tools available (terminal agent) | Write to `<cwd>/<filename>.md`. No prompt |
| No vault, no file tools (claude.ai, chat) | Emit as a Markdown artifact titled `<filename>.md`. No prompt |

- An explicit path from the user always wins. Use it exactly
- Never overwrite. If the target exists, suffix `-2`, `-3`, and state the final name
- Never default to `~/` or any hardcoded path

## Pre-Output Check

Run before emitting. Fix violations silently. Do not report the check.

1. No em dash or en dash anywhere
2. No "you", "your", "I", "we"
3. No banned lexicon from Objectivity
4. Every code block carries a language tag
5. Every `[[link]]` resolves to a real file, or no `[[links]]` at all when no vault
6. Every external link byte-identical to source
7. Frontmatter valid, tags drawn from existing vocabulary when available
8. No section shorter than two lines
9. First character is `-` (frontmatter) or content, never explanation

## CREATE Mode

### Purpose

Convert any input into a minimal, high-density Obsidian note. Maximum signal, zero noise.

### Structure Rules

- Filename is the title. **Never** add a `# Title` heading
- Use `## Section` then `### Subsection` hierarchy only
- No lengthy prose, tutorials, advantages/features sections
- No basic UX instructions ("Press Enter", "Navigate with arrows")

### Skeletons

Starting shapes, not a taxonomy. Borrow the closest, mix two, or ignore them when the content does not fit. Never force a note into a skeleton, and never emit a section just to complete one.

| Shape | Sections |
|-------|----------|
| technique | `## Prerequisites` `## Execution` `## Artifacts` `## Detection` `## OPSEC` |
| tool | `## Install` `## Syntax` `## Flags` `## Examples` `## OPSEC` |
| cheatsheet | One `##` per category, each holding a command table. No prose |
| writeup | `## Recon` `## Foothold` `## Privesc` `## Loot` |
| concept | `## Definition` `## Mechanism` `## Relevance` |
| target | `## Scope` `## Hosts` `## Credentials` `## Findings` |

`## Artifacts` lists what the technique leaves behind: files, registry keys, event IDs, log lines, network signatures.
`## OPSEC` lists what makes it loud and the quieter alternative. Facts only, no advice framing.

### Input Handling

**HTML from THM/HTB/web:**

- Extract commands, syntax, code, tool usage, file paths, attack patterns
- Ignore all prose, nav, UI, ads, bios, tutorial intros/conclusions, "best practices", "features"
- Cut everything that is not pure technical content

**Topic or technique request:**

- Research and write a comprehensive technical note. Accuracy and density first
- Mark anything not verified against a real system with `tested: false`

**Raw terminal / scan output:**

- Structure into logical sections
- Add brief technical context where needed

### Frontmatter

Tags only. That is the whole baseline.

```yaml
---
tags:
  - tool
  - active-directory
---
```

The shape of the note is a tag, not a field. `tool`, `cheatsheet`, `technique`, `writeup`, `privesc` are ordinary tags competing for the same 2-5 slots.

Three optional fields. Add one only when it carries information the body does not, never to fill the block:

| Field | When |
|-------|------|
| `source` | The note came from a URL worth returning to |
| `tested: false` | The note contains commands that were not actually run. Never write `tested: true`, absence is the normal state |
| `mitre` | A real ATT&CK ID is known. Never guess one |

Nothing else. No `type`, no `created`, no `status`, no `aliases` unless the user asks.

### Tags

2-5 tags, lowercase hyphenated. Reuse before inventing.

With a vault detected, read its vocabulary first. Parse frontmatter only, never body lists:

```bash
find "$VAULT" -name '*.md' -not -path '*/.obsidian/*' -exec awk '
  /^---$/ { n++; next }
  n==1 && /^tags:/ { t=1; next }
  n==1 && t && /^[ \t]*-[ \t]/ { sub(/^[ \t]*-[ \t]*/, ""); print; next }
  n==1 && /^[^ \t]/ { t=0 }
  n>1 { nextfile }' {} + | sort | uniq -c | sort -rn | head -40
```

Create a new tag only when no existing tag fits, and state which tag was created.

With no vault, derive tags from note content and state that no vocabulary was available.

### Related Topics

Add only `[[links]]` to files verified present in the vault. Maximum 5. If none verify, or no vault exists, omit the section entirely. Never invent, assume, or suggest links.

### Output Format

````
---
tags:
  - tag1
  - tag2
---

## First Section

content...

### Subsection

```bash
some command
```

prose or table after the block...

| Command | Description |
|---------|-------------|
| `cmd`   | Purpose     |
````

## REFACTOR Mode

### Purpose

Strip verbosity from an existing note. Preserve every link, attachment, and technical detail exactly. Never invent or remove technical content.

### Immutable

Verbatim, always. Only prose is editable.

- Commands, flags, paths, IPs, ports, hashes, credentials
- Code blocks and tool output
- Links (`[[wiki]]`, `[text](url)`, raw URLs)
- Attachments (`![[image.png]]`, `![[doc.pdf]]`) in exact original positions
- YAML frontmatter. Do not add, reorder, or modify fields

### What to Remove

- Verbosity, filler, redundant explanations, unnecessary headings
- Summaries, intros, conclusions, sections not in the original
- Everything in the Objectivity banned lexicon
- Phrases: "This room covered...", "Next steps...", "In this guide..."

### Refactor Process

1. Read the full note before changing anything
2. Identify verbosity: filler sentences, redundant explanations, tutorial language
3. Strip everything that does not add technical value
4. Verify the Immutable list survived byte-identical
5. Run the Pre-Output Check
6. Output with zero meta-commentary

### Backlink Handling

- Move standalone `[[Note]]` links (not used inline) to bottom under `## Related Topics`
- Merge with existing Related Topics if present. Preserve order, no duplicates
- Keep inline links exactly in place
- If a link looks unlikely to exist, keep it unchanged and flag the uncertainty instead of deleting it
- **Never** create new links not in the original

### Output Format

**If source has YAML frontmatter:** start with `---` block, then refactored content.
**If source has no frontmatter:** start directly with content.

End with `## Related Topics` only if standalone links exist in the original.

