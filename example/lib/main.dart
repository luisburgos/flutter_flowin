// A minimal Flowin app: a profile editor whose preview updates as you type.
//
// The single import below also re-exports Flutter's material library, so
// `package:flutter/material.dart` is not needed alongside it.
import 'package:flutter_flowin/flutter_flowin.dart';

void main() => runApp(const ExampleApp());

/// The application root.
///
/// The only wiring Flowin needs: hand [FlowinTheme.light] and
/// [FlowinTheme.dark] to a [MaterialApp]. Every widget below is then styled by
/// the theme, including native Material widgets — Flowin maps its tokens onto
/// [ColorScheme], [TextTheme] and the component themes rather than styling
/// each widget at the call site.
class ExampleApp extends StatelessWidget {
  /// {@macro example_app}
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flowin example',
      theme: FlowinTheme.light,
      darkTheme: FlowinTheme.dark,
      home: const ProfileScreen(),
    );
  }
}

/// A profile editor: the card at the top reflects the fields beneath it.
class ProfileScreen extends StatefulWidget {
  /// {@macro profile_screen}
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<Color> _palette = [
    Colors.blue,
    FlowinDesignColors.error400,
    FlowinDesignColors.warning600,
    FlowinDesignColors.success500,
  ];

  String _name = '';
  String _handle = '';
  Color _accent = _palette.first;
  bool _saved = false;

  bool get _isValid => _name.isNotEmpty && _handle.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Spacing and typography come from the theme rather than hard-coded
    // numbers: `context.spacing` reads the FlowinTokens theme extension, and
    // `context.textTheme` is Material's own, populated by FlowinTheme.
    final spacing = context.spacing;

    return Scaffold(
      // FlowinAppBar takes slot widgets rather than a title string, so the
      // centre slot is styled from the theme like any other text.
      appBar: FlowinAppBar(
        child: Text('Edit profile', style: context.textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileCard(name: _name, handle: _handle, accent: _accent),
            SizedBox(height: spacing.lg),
            FlowinColorPickerField(
              label: 'Accent color',
              predefinedColors: _palette,
              initialColor: _accent,
              onColorChanged: (color) => setState(() => _accent = color),
            ),
            SizedBox(height: spacing.sm),
            FlowinLabeledTextField(
              label: 'Display name',
              hintText: 'Ada Lovelace',
              onChanged: (value) => setState(() => _name = value),
            ),
            SizedBox(height: spacing.sm),
            FlowinLabeledTextField(
              label: 'Handle',
              hintText: 'ada',
              onChanged: (value) => setState(() => _handle = value),
            ),
            SizedBox(height: spacing.lg),
            Align(
              alignment: Alignment.centerRight,
              child: FlowinButton.filled(
                label: _saved ? 'Saved' : 'Save profile',
                // A null callback disables the button; the theme resolves the
                // disabled appearance.
                onPressed: _isValid
                    ? () => setState(() => _saved = true)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The profile as it currently stands.
///
/// Presentational: it renders the values it is given and holds no state.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.handle,
    required this.accent,
  });

  final String name;
  final String handle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();

    return FlowinCard(
      backgroundColor: accent.withValues(alpha: 0.12),
      padding: EdgeInsets.all(context.spacing.md),
      child: Row(
        spacing: context.spacing.md,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            child: SizedBox.square(
              dimension: FlowinDesignSpace.space1200,
              child: Center(
                child: Text(
                  initial,
                  // The accent is user-picked, so the text drawn on top of it
                  // is resolved for contrast rather than assumed readable.
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AccessibleColorConfig(
                      seedColor: accent,
                      backgroundColor: accent,
                      compliance: ContrastCompliance.largeText,
                    ).foregroundColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'No name yet' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  handle.isEmpty ? '@handle' : '@$handle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
