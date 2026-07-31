---
description: "Use when implementing features, bug fixes, refactors, or any code change in this repo. After every implementation, leave the workspace with no analyzer errors, warnings, or lint violations, including pre-existing issues outside the touched files."
name: "Workspace Validation Gate"
applyTo: "**/*.dart"
---

# Workspace Validation Gate

- After every code implementation, run validation before concluding the task.
- Do not stop at fixing only the files you touched. Clear any remaining errors, warnings, and lint violations anywhere in the workspace.
- Treat warnings and lints as blocking, not optional cleanup.
- For Dart and Flutter changes, prefer workspace-level validation such as `flutter analyze` or an equivalent full-repo check.
- If validation surfaces issues outside the current change, fix them before reporting completion unless doing so would be unsafe or out of scope.
- If a remaining issue cannot be resolved safely in the same task, stop and explain the blocker instead of claiming the work is complete.
- Do not report a task as finished until validation returns a clean result.
