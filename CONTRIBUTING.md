# Contributing to Flutter Flowin

## Getting set up

This project pins its Flutter SDK with [FVM][fvm_link] (`.fvmrc` → Flutter
`3.44.0`). **Run all Flutter/Dart commands through `fvm`** (e.g.
`fvm flutter test`, `fvm dart format .`) so you use the pinned SDK rather than
whatever is first on your `PATH`.

```sh
fvm install        # fetch the pinned Flutter SDK declared in .fvmrc
lefthook install   # wire the git hooks (see https://lefthook.dev to install the binary)
```

To work on the package and a consuming app side by side, depend on it by path:

```yaml
dependencies:
  flutter_flowin:
    path: ../flutter_flowin
```

---

## The pre-push hook 🪝

A **pre-push git hook** (managed by [lefthook][lefthook_link]) mirrors the CI
gates — `dart format`, `flutter analyze`, `flutter test`, and a markdown
spell-check ([cspell][cspell_link]) — and **blocks the push** if any fail, so
problems are caught locally before a PR is opened.

The Flutter/Dart commands run via `fvm`. The spell-check uses a local/global
`cspell` if available and falls back to `npx cspell`; if neither is installed it
is skipped locally, and CI still enforces it.

The configuration lives in [`lefthook.yml`](lefthook.yml). To run it on demand
without pushing:

```sh
lefthook run pre-push
```

---

## Continuous Integration 🤖

The [GitHub Actions workflow][github_actions_link] is powered by
[Very Good Workflows][very_good_workflows_link]. On each pull request and push
it formats, lints and tests the code, using
[Very Good Analysis][very_good_analysis_link] for a strict set of analysis
options. Coverage is enforced by [Very Good Workflows][very_good_coverage_link].

The `showcase/` and `example/` apps are separate packages, excluded from the
root analysis options, so a dedicated `sub_packages` job analyzes and tests each
of them. Without it they break silently whenever the library's API changes.

---

## Running tests 🧪

Install [very_good_cli][very_good_cli_link] once:

```sh
dart pub global activate very_good_cli
```

Then:

```sh
very_good test --coverage
```

Coverage is enforced at 100%. `lib/src/vendor/` is excluded — it holds
third-party source vendored verbatim, held to its authors' style so it stays
diffable against upstream, and the gate should measure the code we wrote. Both
the CI workflow and the pre-push hook carry that exclusion so they cannot drift.

To view the report, use [lcov](https://github.com/linux-test-project/lcov):

```sh
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## Changelog 📓

[`CHANGELOG.md`](CHANGELOG.md) is **generated, not hand-edited**. It is built
from [Conventional Commit][conventional_commits_link] subjects by
[conventional-changelog][conventional_changelog_link].

One-time setup:

```sh
npm install        # fetch the changelog tooling
```

### Cutting a release

The version lives in four files and the changelog is generated from commits, so
the order matters. **Bump first, generate second** — the generator writes a
section for whatever version it finds, so running it early files new work under
the release already published.

1. **Bump the version in all four places**, to the same value:

   | File | Read by |
   |---|---|
   | `pubspec.yaml` | pub.dev and the published package |
   | `package.json` | conventional-changelog |
   | `showcase/pubspec.yaml` | the showcase app |
   | `flowinVersion` in `showcase/lib/app_info/flowin_app_info_service.dart` | the showcase's version label |

   `showcase/test/app_version_test.dart` fails if the last three drift from the
   first. **Nothing checks `package.json`** — see the warning below.

2. **Regenerate the changelog:**

   ```sh
   npm run changelog
   ```

3. **Commit, merge, then tag the merge commit** and push the tag. The tag is
   what bounds the next release's commit range.

4. **Publish:**

   ```sh
   fvm dart pub publish
   ```

   Published versions are immutable: a version can never be replaced or
   deleted, only retracted within 7 days, which hides it rather than removing
   it. Metadata like `homepage` and `topics` therefore only reaches pub.dev
   with a new release.

> **`package.json` is the one to remember.** The `-s` flag means "same
> release", and being a Node tool the generator reads the version from
> `package.json` — *not* `pubspec.yaml`. Leave it behind and the command still
> succeeds, silently rewriting the previous version's section instead of
> opening a new one. It is the only one of the four with no test guarding it.

The generator also *prepends* rather than merges, so running it twice for one
version produces two headings. To rewrite a section, delete the old heading (or
clear the file) and regenerate.

Unlike the sibling Flutter apps, which use the stock `angular` preset, this
package extends `conventionalcommits` via
[`.changelogrc.js`](.changelogrc.js) so that `docs`, `test`, `build`, `ci`,
`refactor`, and `chore` get their own sections instead of being dropped. The
apps only surface `feat` / `fix` / `perf` / `revert`, which suits release notes
for end users. This package is consumed by those apps, so tooling and
documentation work is worth recording too. Only `style` is hidden.

Two notes:

- The tooling is a real `devDependency` rather than an `npx` one-off, because
  the config file has to `require` the preset and `npx`'s isolated install
  directory is not on that resolution path. `node_modules/` is gitignored.
- The file is excluded from the spell-check gate in both CI and the pre-push
  hook, because it holds verbatim commit subjects rather than authored prose.

[conventional_changelog_link]: https://github.com/conventional-changelog/conventional-changelog
[conventional_commits_link]: https://www.conventionalcommits.org
[cspell_link]: https://cspell.org
[fvm_link]: https://fvm.app
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[lefthook_link]: https://lefthook.dev
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
