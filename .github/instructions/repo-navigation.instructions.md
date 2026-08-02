---
name: repo-navigation
description: "Use when exploring, locating, or understanding code in this repository. Enforces search_codebase as the mandatory first action before any file read, directory listing, or regex search. Covers compas tool usage, correct workflow order, and anti-patterns to avoid."
applyTo: "**"
---

## MANDATORY RULE

For ANY task where you do not already know the exact file path and line number, your FIRST action MUST be `search_codebase`.

NEVER use `list_dir`, `read_file`, or regex search for initial exploration.
NEVER browse the directory tree to get oriented before searching.
NEVER assume you know where code lives because of file names or folder structure.

## Compas (Local Semantic Search)

This repo is indexed by compas. It finds symbols by natural language meaning and knows the call graph. It is faster and more accurate than manual browsing.

### Tools

| Tool | Use When |
|------|----------|
| `search_codebase` | ALWAYS FIRST. Any time you need to locate, understand, or explore code. |
| `get_symbol_graph` | After search, when you need to trace callers/callees of a specific symbol. |

### Correct Workflow

1. Search: `search_codebase({ query: "...", limit: 10 })`
2. Deepen (optional): `get_symbol_graph({ symbol: "..." })`
3. Read: Open ONLY the exact file(s) and line ranges compas returned

### What NOT to do

WRONG: Reading `lib/foo/bar.dart` because "the logic is probably there."
RIGHT: `search_codebase({ query: "how does X work", limit: 10 })` then read only the confirmed results.
