import 'package:equatable/equatable.dart';

/// Which widget fills the sheet's body slot.
enum BodyChoice {
  /// No body at all.
  none('None'),

  /// A paragraph that insets itself to line up with the footer.
  text('Text'),

  /// A text field and a chip group.
  form('Form'),

  /// A column of item buttons.
  list('Item list'),

  /// A panel reaching the card edge, with no inset of its own.
  fullBleed('Full bleed');

  const BodyChoice(this.label);

  /// The choice's name in the knob's dropdown.
  final String label;
}

/// How many actions the sheet's footer carries.
enum FooterChoice {
  /// No footer.
  none('None'),

  /// One action, stretched to full width.
  single('One action'),

  /// Two actions in equal-width columns.
  pair('Two actions');

  const FooterChoice(this.label);

  /// The choice's name in the knob's dropdown.
  final String label;
}

/// The full state of the previewed sheet.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class SheetConfig extends Equatable {
  /// {@macro sheet_config}
  const SheetConfig({
    this.hasIcon = false,
    this.hasSubtitle = false,
    this.hasClose = true,
    this.body = BodyChoice.none,
    this.footer = FooterChoice.none,
  });

  /// Whether the header carries an icon, which displaces the title.
  final bool hasIcon;

  /// Whether the header carries a subtitle.
  final bool hasSubtitle;

  /// Whether the header carries a close button.
  final bool hasClose;

  /// What fills the body slot.
  final BodyChoice body;

  /// What fills the footer slot.
  final FooterChoice footer;

  /// A copy with the given fields replaced.
  SheetConfig copyWith({
    bool? hasIcon,
    bool? hasSubtitle,
    bool? hasClose,
    BodyChoice? body,
    FooterChoice? footer,
  }) => SheetConfig(
    hasIcon: hasIcon ?? this.hasIcon,
    hasSubtitle: hasSubtitle ?? this.hasSubtitle,
    hasClose: hasClose ?? this.hasClose,
    body: body ?? this.body,
    footer: footer ?? this.footer,
  );

  @override
  List<Object?> get props => [hasIcon, hasSubtitle, hasClose, body, footer];
}
