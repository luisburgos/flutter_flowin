import 'package:flowin_showcase/components/playground/inspector/flowin_playground_inspector.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// One action pinned to the bottom of a [FlowinPlaygroundInspector].
///
/// Actions do something with the current configuration rather than change it —
/// presenting it as a modal, copying it, resetting it — which is why they sit
/// apart from the knobs behind a divider.
@immutable
class FlowinPlaygroundAction {
  /// {@macro flowin_playground_action}
  const FlowinPlaygroundAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  /// The action's label.
  final String label;

  /// Called when the action is pressed.
  final VoidCallback onPressed;

  /// An optional leading icon.
  final Widget? icon;
}

/// The inspector's pinned action region.
class FlowinPlaygroundActions extends StatelessWidget {
  /// {@macro flowin_playground_actions}
  const FlowinPlaygroundActions({required this.actions, super.key});

  /// The actions, in order.
  final List<FlowinPlaygroundAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: FlowinDesignBorders.regular),
        Padding(
          padding: const EdgeInsets.all(FlowinDesignSpace.space600),
          child: Column(
            spacing: FlowinDesignSpace.space200,
            children: [
              for (final action in actions)
                // Full width so an action reads as belonging to the inspector
                // rather than as one more control among the knobs above it.
                SizedBox(
                  width: double.infinity,
                  child: FlowinButton.tonal(
                    size: FlowinButtonSize.md,
                    icon: action.icon,
                    onPressed: action.onPressed,
                    label: action.label,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
