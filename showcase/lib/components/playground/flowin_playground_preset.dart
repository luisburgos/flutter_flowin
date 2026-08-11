import 'package:equatable/equatable.dart';
import 'package:flowin_showcase/components/playground/flowin_playground.dart';

/// A named starting configuration for a [FlowinPlayground].
///
/// Presets exist so a shape can be demonstrated *and* mutated from. A fixed
/// example shows the result; a preset shows the settings that produce it and
/// leaves them editable.
class FlowinPlaygroundPreset<T> extends Equatable {
  /// {@macro flowin_playground_preset}
  const FlowinPlaygroundPreset({
    required this.label,
    required this.config,
    this.summary,
  });

  /// The preset's name, shown in the inspector's preset list.
  final String label;

  /// The configuration this preset applies.
  final T config;

  /// One line on what the shape is for, shown when the preset is active.
  final String? summary;

  @override
  List<Object?> get props => [label, config, summary];
}
