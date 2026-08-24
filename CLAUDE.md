# Agent instructions for flutter_flowin

Read CONTRIBUTING.md first — it is the authoritative process document. The
rules below are the hard gates an agent must not cross on its own judgment.

## Hard gates

- **Never run `dart pub publish` (or any publish/upload) without an explicit,
  separate approval of that exact step.** "Cut the release" authorizes the
  runbook's preparatory steps (bump, changelog, PR, tag) — it does NOT
  authorize the upload. Run the dry-run, present its output, then stop and
  ask. Publishing is immutable; a wrong upload cannot be replaced.
- **Do not push feature branches or open PRs before the user validates the
  change** in the running app and approves, unless they explicitly ask for
  the push/PR. Commit locally and report "committed, not pushed".

## Release checklist pointers

- The version lives in **five** places (see CONTRIBUTING's table, including
  the README install snippet); `showcase/test/app_version_test.dart` is the
  drift guard — run it after any bump.
- Bump first, changelog second; tag the merge commit; nothing lands on main
  between bump and tag.
