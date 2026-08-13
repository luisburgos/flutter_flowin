/// {@template flowin_design_icon_size}
/// The Flowin icon-size scale.
///
/// Each size carries both a pixel [value] and a paired [stroke] weight so that
/// icon thickness scales proportionally with size.
/// {@endtemplate}
enum FlowinDesignIconSize {
  /// Extra-small — 12px.
  xs(12),

  /// Small — 16px.
  sm(16),

  /// Medium — 20px.
  md(20),

  /// Large — 24px.
  lg(24),

  /// Extra-large — 32px.
  xl(32),

  /// Extra-extra-large — 40px.
  xxl(40);

  /// {@macro flowin_design_icon_size}
  const FlowinDesignIconSize(this.value);

  /// The icon side length in logical pixels.
  final double value;

  /// Returns the [FlowinDesignIconSize] whose [value] equals [value].
  ///
  /// Throws an [ArgumentError] when no size matches.
  static FlowinDesignIconSize fromValue(int value) {
    return FlowinDesignIconSize.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid icon size value'),
    );
  }

  /// The stroke weight paired with this size.
  double get stroke {
    switch (this) {
      case FlowinDesignIconSize.xs:
        return 1.25;
      case FlowinDesignIconSize.sm:
        return 1.5;
      case FlowinDesignIconSize.md:
        return 1.75;
      case FlowinDesignIconSize.lg:
        return 2;
      case FlowinDesignIconSize.xl:
        return 2.5;
      case FlowinDesignIconSize.xxl:
        return 3;
    }
  }

  /// The default icon size ([md]).
  static const FlowinDesignIconSize defaultSize = FlowinDesignIconSize.md;
}
