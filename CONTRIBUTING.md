# Contributing to Flutter Flowin

## What this is

Flowin is a design system: design tokens, a Material-mapped theme, and the
component library built on them, published to
[pub.dev](https://pub.dev/packages/flutter_flowin).

It is a published package, so its public API is a commitment: a breaking change
costs everyone who has adopted it. Treat additions as cheap and removals as
expensive.

Four directories are easy to confuse:

| Directory | What it is |
|---|---|
| `lib/` | the package itself — the only code that ships to consumers |
| `showcase/` | a companion app cataloguing every component, published to [GitHub Pages](https://luisburgos.github.io/flutter_flowin/) |
| `example/` | one small app that pub.dev renders on the package's Example tab |
| `lib/src/vendor/` | third-party source vendored verbatim — see below before touching it |

The package has **two entry points**, and which one exports a widget is a
design decision, not a convenience:

| Barrel | What belongs there |
|---|---|
| `lib/flutter_flowin.dart` | the **catalogued surface** — components with a look of their own. Everything exported here must have a showcase card; the showcase's catalogue-coverage test enforces it |
| `lib/primitives.dart` | **primitives** — public behavioral building blocks with no visual identity (e.g. `FlowinFadePage`), consumed by catalogued components and by apps composing their own. Not swept by the catalogue test |

The layering reads: foundations (tokens) → primitives (behavior) →
components (catalogued) → apps. If a new export would need an *excuse* in the
catalogue-coverage exclusion list rather than a card, it probably belongs in
`primitives.dart` instead.

---

## Opening an issue

**Issues live in [`flowin_pm`](https://github.com/luisburgos/flowin_pm/issues),
not in this repository.** That is where the work for every Flowin project is
tracked, so an issue filed here will likely be missed.

Include the package version, the Flutter version, and what you expected to
happen. If it is visual, the
[showcase](https://luisburgos.github.io/flutter_flowin/) is the fastest way to
show it.

---

## Making a change

### Branch from `main`

Name the branch for the kind of change, matching the commit type:
`feat/…`, `fix/…`, `chore/…`, `refactor/…`, `docs/…`.

### Write Conventional Commit subjects

[Conventional Commits][conventional_commits_link] are **required, not
preferred**: `CHANGELOG.md` is generated from commit subjects, so a vague or
malformed subject becomes a vague or malformed release note that cannot be
edited afterwards without rewriting history.

```
feat(chips): add a leading icon slot
fix(theme): restore the disabled border color
```

Use `!` or a `BREAKING CHANGE:` footer for anything that breaks the public API.

### Open a pull request

This repository **squash-merges only**, so the **PR title becomes the commit
subject on `main`** — it is permanent history, not a label. It must be a valid
Conventional Commit subject; CI enforces this with `semantic_pull_request`, and
a merge is blocked until it passes.

The body is worth writing properly. It is the record of *why* a change was
made, which the diff cannot carry.

### Where the code goes

Component and token work belongs in `lib/`, with the showcase updated in the
same change so the catalogue never lags the library.

`lib/src/vendor/` is third-party source, vendored verbatim under its own
license. It is deliberately excluded from analysis and coverage so it stays
diffable against upstream. **Do not reformat it to match house style** — see
the README in that directory for what was taken and why.

---

## Setup

This project pins its Flutter SDK with [FVM][fvm_link] (`.fvmrc` → Flutter
`3.44.0`). **Run every Flutter and Dart command through `fvm`** — for example
`fvm flutter test` — so you use the pinned SDK rather than whatever is first on
your `PATH`.

```sh
fvm install        # fetch the pinned Flutter SDK declared in .fvmrc
lefthook install   # wire the git hooks (see https://lefthook.dev for the binary)
npm install        # changelog tooling, needed only when cutting a release
```

To develop the package and a consuming app side by side, depend on it by path:

```yaml
dependencies:
  flutter_flowin:
    path: ../flutter_flowin
```

---

## Checks

Four gates guard every change, and they run in two places.

| Gate | Command |
|---|---|
| Format | `fvm dart format .` |
| Analyze | `fvm flutter analyze` |
| Test, with 100% coverage | `fvm exec very_good test --coverage --min-coverage 100 --exclude-coverage "lib/src/vendor/**"` |
| Spell-check (Markdown) | `npx cspell --config .github/cspell.json "**/*.md" --exclude CHANGELOG.md` |

A **pre-push hook** ([lefthook][lefthook_link]) runs all four and blocks the
push if any fail, so problems surface before a PR exists. To run it on demand:

```sh
lefthook run pre-push
```

CI runs the same gates on every pull request, via
[Very Good Workflows][very_good_workflows_link]. Because `showcase/` and
`example/` are separate packages excluded from the root analysis options, a
`sub_packages` job analyzes and tests each of them too — without it they break
silently whenever the library's API changes.

Two exclusions are deliberate, and both are mirrored in CI and the hook so they
cannot drift:

- **`lib/src/vendor/` is excluded from coverage.** The 100% gate should measure
  the code we wrote, not vendored third-party UI.
- **`CHANGELOG.md` is excluded from spell-check.** It holds verbatim commit
  subjects, so a historical typo would fail the build on a word nobody can edit.

Install [very_good_cli][very_good_cli_link] once for the coverage gate:

```sh
dart pub global activate very_good_cli
```

To read the report, use [lcov](https://github.com/linux-test-project/lcov):

```sh
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## Releasing

The version lives in four files and the changelog is generated from commits, so
the order matters. **Bump first, generate second** — the generator writes a
section for whatever version it finds, so running it early files new work under
the release already published.

### 1. Bump the version in all five places, to the same value

| File | Read by |
|---|---|
| `pubspec.yaml` | pub.dev and the published package |
| `package.json` | conventional-changelog |
| `showcase/pubspec.yaml` | the showcase app |
| `flowinVersion` in `showcase/lib/app_info/flowin_app_info_service.dart` | the showcase's version label |
| the `flutter_flowin: ^X.Y.Z` install snippet in `README.md` | everyone reading the package's front page |

`showcase/test/app_version_test.dart` fails if any of them drift apart.

> **`package.json` is the one to remember.** The `-s` flag means "same
> release", and being a Node tool the generator reads the version from
> `package.json` — *not* `pubspec.yaml`. Left behind, the command still
> succeeds: it silently rewrites the previous version's section instead of
> opening a new one.

### 2. Regenerate the changelog

```sh
npm run changelog
```

It *prepends* rather than merges, so running it twice for one version produces
two headings. To rewrite a section, delete the old heading and regenerate.

### 3. Merge, then tag the merge commit

```sh
git tag <version> && git push origin <version>
```

The tag bounds the next release's commit range, so it has to exist before the
next changelog run.

### 4. Publish — only after an explicit go

Publishing is the release's one irreversible step, so it has a human gate:
run the dry-run, show its output, and **wait for an explicit approval of the
publish itself** — approval of the release *process* ("cut the release") is
not approval of the upload. This applies doubly to agents driving the
runbook: steps 1–3 are theirs to execute, step 4 is not, however clean the
dry-run looks.

```sh
fvm dart pub publish --dry-run   # review this together first
fvm dart pub publish             # only after the explicit go
```

Published versions are **immutable**: a version can never be replaced or
deleted, only retracted within 7 days, which hides it rather than removing it.
Metadata such as `homepage`, `description` and `topics` therefore only reaches
pub.dev with a new release.

### About the changelog preset

`CHANGELOG.md` is **generated, not hand-edited**. This package extends
`conventionalcommits` via [`.changelogrc.js`](.changelogrc.js) so that `docs`,
`test`, `build`, `ci`, `refactor` and `chore` each get their own section
instead of being dropped. The stock preset surfaces only
`feat` / `fix` / `perf` / `revert`, which suits an application's release notes
but hides the tooling and documentation work that matters to a package's
consumers. That file's header comment carries the full rationale.

[conventional_commits_link]: https://www.conventionalcommits.org
[fvm_link]: https://fvm.app
[lefthook_link]: https://lefthook.dev
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
