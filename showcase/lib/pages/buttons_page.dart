import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Demonstrates every button widget, variant, size and state.
class ButtonsPage extends StatefulWidget {
  /// {@macro buttons_page}
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  int _taps = 0;

  void _tap() => setState(() => _taps++);

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.paged(
      title: 'Buttons',
      sections: [
        ShowcaseSection(
          chipLabel: 'Variants',
          title: 'FlowinButton — variants',
          description:
              'Each variant maps to a native Material button, styled '
              'entirely by the theme. Tapped $_taps times.',
          children: [
            for (final variant in FlowinButtonVariant.values)
              ShowcaseRow(
                label: variant.name,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FlowinButton(
                    variant: variant,
                    onPressed: _tap,
                    label: 'Continue',
                  ),
                ),
              ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Sizes',
          title: 'FlowinButton — sizes',
          description:
              'Size drives min height, content padding, icon size and '
              'label style.',
          children: [
            for (final size in FlowinButtonSize.values)
              ShowcaseRow(
                label: size.name,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FlowinButton.filled(
                    size: size,
                    onPressed: _tap,
                    label: 'Save changes',
                  ),
                ),
              ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Icon & disabled',
          title: 'FlowinButton — with icon & disabled',
          children: [
            ShowcaseRow(
              label: 'leading icon',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FlowinButton.tonal(
                  icon: FDIcons.share.toIcon(),
                  onPressed: _tap,
                  label: 'Share',
                ),
              ),
            ),
            const ShowcaseRow(
              label: 'disabled (onPressed: null)',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FlowinButton(label: 'Unavailable', onPressed: null),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Icon button',
          title: 'FlowinIconButton',
          description: 'Circular icon-only buttons across variants and sizes.',
          children: [
            ShowcaseRow(
              label: 'variants',
              child: Row(
                spacing: FlowinDesignSpace.space200,
                children: [
                  for (final variant in FlowinIconButtonVariant.values)
                    FlowinIconButton(
                      variant: variant,
                      icon: FDIcons.plus.toIcon(),
                      onPressed: _tap,
                    ),
                ],
              ),
            ),
            ShowcaseRow(
              label: 'sizes (xs / sm / md)',
              child: Row(
                spacing: FlowinDesignSpace.space200,
                children: [
                  for (final size in FlowinButtonSize.values)
                    FlowinIconButton.tonal(
                      size: size,
                      icon: FDIcons.settings.toIcon(),
                      onPressed: _tap,
                    ),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Item button',
          title: 'FlowinItemButton',
          description: 'Full-width, left-aligned rows — the list/menu button.',
          children: [
            for (final variant in FlowinItemButtonVariant.values)
              ShowcaseRow(
                label: variant.name,
                child: FlowinItemButton(
                  variant: variant,
                  icon: FDIcons.timer.toIcon(),
                  onPressed: _tap,
                  label: 'Session settings',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
