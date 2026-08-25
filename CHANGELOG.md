## [0.3.0](https://github.com/luisburgos/flutter_flowin/compare/0.2.0...0.3.0) (2026-08-25)

### ⚠ BREAKING CHANGES

* **color-picker:** `FlowinColorPickerField` no longer bundles a custom-color picker. To keep the custom-color swatch, pass `onPickCustomColor` with a picker of your choice; see the showcase for an example. Without it the field shows the predefined swatches only.

### Features

* **color-picker:** inject the custom-color picker instead of bundling one ([#66](https://github.com/luisburgos/flutter_flowin/issues/66)) ([15d6f05](https://github.com/luisburgos/flutter_flowin/commit/15d6f05f8751321c8c7c3da4854c702c5aa1eda1))

### Chores

* add .pubignore to keep dev files out of the published archive ([#67](https://github.com/luisburgos/flutter_flowin/issues/67)) ([ae49570](https://github.com/luisburgos/flutter_flowin/commit/ae4957042b052b13e2e1c0db72e6ce833e4e27d2))
* guard the README version and gate publishing behind approval ([#65](https://github.com/luisburgos/flutter_flowin/issues/65)) ([e6cfdd5](https://github.com/luisburgos/flutter_flowin/commit/e6cfdd5c6e2ba74c15fbf28e7012593ecafeff15))
## [0.2.0](https://github.com/luisburgos/flutter_flowin/compare/0.1.1...0.2.0) (2026-08-24)

### Features

* cross-fade page transitions for the chip pager and showcase tabs ([#60](https://github.com/luisburgos/flutter_flowin/issues/60)) ([7130f20](https://github.com/luisburgos/flutter_flowin/commit/7130f203b27f3885cd668021092ca52bfcaab683))
* **showcase:** add LowframerScribble and write the Typography art with it ([#63](https://github.com/luisburgos/flutter_flowin/issues/63)) ([e3bf77e](https://github.com/luisburgos/flutter_flowin/commit/e3bf77e44cde0090313052cbbb74b800ee09c091))
* **showcase:** animate the web splash as a rainbow sound wave ([#57](https://github.com/luisburgos/flutter_flowin/issues/57)) ([1afc0b7](https://github.com/luisburgos/flutter_flowin/commit/1afc0b76f55f825dd1668e66a32ed7f1310b15e7))
* **showcase:** cap the tab content width on large screens ([#59](https://github.com/luisburgos/flutter_flowin/issues/59)) ([05d8c42](https://github.com/luisburgos/flutter_flowin/commit/05d8c420cb9d33dc21bb94cbba6ff2bb9789e746))
* **showcase:** give every catalogue card a lowframer cover art ([#58](https://github.com/luisburgos/flutter_flowin/issues/58)) ([3200258](https://github.com/luisburgos/flutter_flowin/commit/320025827f3eec0fb93d02f3251ba66cb003375b))

### Bug Fixes

* **showcase:** match the cover arts to their components' real anatomy ([#62](https://github.com/luisburgos/flutter_flowin/issues/62)) ([a7b6d8c](https://github.com/luisburgos/flutter_flowin/commit/a7b6d8ce886f020bba65e43e148b44803c05efd3))

### Refactors

* extract FlowinKeepAlivePage and adopt it in the showcase tabs ([#61](https://github.com/luisburgos/flutter_flowin/issues/61)) ([1ba4f72](https://github.com/luisburgos/flutter_flowin/commit/1ba4f72843387ad5dd8e7143b56821bf6a3491c9))

### Chores

* **showcase:** put Components before Foundations in the Library pager ([#56](https://github.com/luisburgos/flutter_flowin/issues/56)) ([e37082b](https://github.com/luisburgos/flutter_flowin/commit/e37082beba70ab8cb865068d33f235a4467d5e77))
* track the shared .claude config ([154cddb](https://github.com/luisburgos/flutter_flowin/commit/154cddba45cac4717e4bbc85e7b47a279d5f1142))
## [0.1.1](https://github.com/luisburgos/flutter_flowin/compare/0.1.0...0.1.1) (2026-08-14)

### Bug Fixes

* **action-sheet:** centre the header title with the close button ([#51](https://github.com/luisburgos/flutter_flowin/issues/51)) ([7e8eca2](https://github.com/luisburgos/flutter_flowin/commit/7e8eca2231f7a4f367fb50107f19d789a742f458))
* **action-sheet:** stop the close button dictating the header's layout ([#52](https://github.com/luisburgos/flutter_flowin/issues/52)) ([5188be2](https://github.com/luisburgos/flutter_flowin/commit/5188be2c96ed0f8595d502c5537552877c00cb5b))
* **color-picker:** show the picked color in the custom swatch ([#50](https://github.com/luisburgos/flutter_flowin/issues/50)) ([847b831](https://github.com/luisburgos/flutter_flowin/commit/847b8315d901385b3db2f026166cc5b96e7880fd))
* **showcase:** open in the device's appearance, not always light ([#49](https://github.com/luisburgos/flutter_flowin/issues/49)) ([9052189](https://github.com/luisburgos/flutter_flowin/commit/905218931b980950477641f83c2eca5f341b0be9))
* **showcase:** paint the page dark before Flutter's first frame ([#54](https://github.com/luisburgos/flutter_flowin/issues/54)) ([5c9af54](https://github.com/luisburgos/flutter_flowin/commit/5c9af54834185abbc151bd2b84d00487c90c28fd))

### Documentation

* **action-sheet:** explain the header's two title-to-subtitle gaps ([#53](https://github.com/luisburgos/flutter_flowin/issues/53)) ([201050f](https://github.com/luisburgos/flutter_flowin/commit/201050f3a33af18e0c1e79964730f2c2b3062682))
* **contributing:** restructure around how a contribution actually happens ([#47](https://github.com/luisburgos/flutter_flowin/issues/47)) ([a29962c](https://github.com/luisburgos/flutter_flowin/commit/a29962c43a778116934455348aba08074458af65))
* **readme:** surface the live showcase above the fold ([#48](https://github.com/luisburgos/flutter_flowin/issues/48)) ([da10c21](https://github.com/luisburgos/flutter_flowin/commit/da10c21bbbafd0d66db7b59db08bc363760f4760))

### Chores

* **pubspec:** homepage, topics, and the release procedure ([#46](https://github.com/luisburgos/flutter_flowin/issues/46)) ([71a09a5](https://github.com/luisburgos/flutter_flowin/commit/71a09a55dc25f5ee68fbe209a8300c237f218bfe))

## 0.1.0 (2026-08-13)

Initial release of the Flowin design system: design tokens, a Material-mapped
theme, and the component library built on them. History was reset before this
release, so the entries below cover the work since that point rather than the
full development of the package.

### Features

* **example:** add the example app pub.dev looks for ([#43](https://github.com/luisburgos/flutter_flowin/issues/43)) ([3d25eb4](https://github.com/luisburgos/flutter_flowin/commit/3d25eb45134a9ecc0d6158733277416084210dd7)), closes [luisburgos/flowin_pm#40](https://github.com/luisburgos/flowin_pm/issues/40)
* **pubspec:** enable publishing to pub.dev ([c5a4436](https://github.com/luisburgos/flutter_flowin/commit/c5a4436c05801748b40326280660ef7d31d4cd19))

### Bug Fixes

* **license:** name the copyright holder ([a150ec3](https://github.com/luisburgos/flutter_flowin/commit/a150ec3d1cf2df22ada6c42062c05760d936b470))

### Documentation

* split contributor instructions into CONTRIBUTING.md ([584872f](https://github.com/luisburgos/flutter_flowin/commit/584872f620c3be9b5ae18ddc0b01670565c2a8d3))

### Refactors

* **color-picker:** vendor the cross-platform picker, drop the git dependency ([#41](https://github.com/luisburgos/flutter_flowin/issues/41)) ([c64a621](https://github.com/luisburgos/flutter_flowin/commit/c64a62103d1317130c2c950f1bf0c7e37b388512)), closes [luisburgos/flowin_pm#40](https://github.com/luisburgos/flowin_pm/issues/40)

### Chores

* initial commit ([9631658](https://github.com/luisburgos/flutter_flowin/commit/9631658c5985b98ed99de8cfab2a2013825a67d3))
* **pubspec:** clear the publishing metadata warnings ([#42](https://github.com/luisburgos/flutter_flowin/issues/42)) ([74a5d3f](https://github.com/luisburgos/flutter_flowin/commit/74a5d3f7297ea331c760b155cd21baa41b87961f)), closes [luisburgos/flowin_pm#40](https://github.com/luisburgos/flowin_pm/issues/40)
* **pubspec:** describe what the package actually is ([#44](https://github.com/luisburgos/flutter_flowin/issues/44)) ([b6b1f9f](https://github.com/luisburgos/flutter_flowin/commit/b6b1f9f626c3e3523e76bcc3ee31cd5eb8633163)), closes [luisburgos/flowin_pm#40](https://github.com/luisburgos/flowin_pm/issues/40)
