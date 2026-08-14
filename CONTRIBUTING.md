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

First-time setup, then regenerate the newest release section:

```sh
npm install        # once, to fetch the changelog tooling
npm run changelog
```

**Bump the version before generating, not after** — and bump it in **both**
`pubspec.yaml` and `package.json`. The `-s` flag in the script means "same
release": the generator writes a section for the version currently in
`package.json`, not the pubspec, collecting every commit since the previous tag.
Leaving `package.json` behind silently regenerates the *previous* version's
section instead of opening a new one.

It also *prepends* rather than merges, so running it twice for the same version
produces two headings. To rewrite a section, clear the file (or delete the
heading) and regenerate.

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
