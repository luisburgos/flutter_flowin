// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinActionSheet', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpApp(FlowinActionSheet(title: 'Hello'));
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('renders subtitle and header icon when provided', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinActionSheet(
          title: 'Title',
          subtitle: 'Subtitle',
          headerIcon: Icon(Icons.palette),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);
    });

    testWidgets('renders the subtitle with no header icon', (tester) async {
      // The subtitle used to be rendered only as a sibling of the title in
      // the icon branch, so a sheet with a subtitle and no icon dropped it
      // silently. The test above did not catch that because it always passed
      // an icon.
      await tester.pumpApp(
        FlowinActionSheet(title: 'Title', subtitle: 'Subtitle'),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('renders the title exactly once, with or without an icon', (
      tester,
    ) async {
      // The title moves between the top row and the block below it depending
      // on the icon. Rendering it in both would duplicate it.
      for (final icon in <Widget?>[null, Icon(Icons.palette)]) {
        await tester.pumpApp(
          FlowinActionSheet(
            title: 'Title',
            subtitle: 'Subtitle',
            headerIcon: icon,
          ),
        );
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Subtitle'), findsOneWidget);
      }
    });

    testWidgets('renders the body child', (tester) async {
      await tester.pumpApp(
        FlowinActionSheet(title: 'Title', body: Text('Body content')),
      );
      expect(find.text('Body content'), findsOneWidget);
    });

    testWidgets('renders the footer child', (tester) async {
      await tester.pumpApp(
        FlowinActionSheet(
          title: 'Title',
          footer: FlowinActionSheetFooter(
            right: FlowinButton.filled(onPressed: () {}, label: 'OK'),
          ),
        ),
      );
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('shows the close button when displayClose is true', (
      tester,
    ) async {
      await tester.pumpApp(FlowinActionSheet(title: 'Title'));
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('hides the close button when displayClose is false', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinActionSheet(title: 'Title', displayClose: false),
      );
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('fires onClose when the close button is tapped', (
      tester,
    ) async {
      var closed = false;
      await tester.pumpApp(
        FlowinActionSheet(title: 'Title', onClose: () => closed = true),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('sizes the close button to xs (32) to match legacy', (
      tester,
    ) async {
      await tester.pumpApp(FlowinActionSheet(title: 'Title'));

      // Contract: the close button is sized xs (32x32 visual square via
      // fixedSize) rather than the defaulted sm (40). The rendered IconButton
      // box stays 48 due to Material's default tap-target padding, so assert on
      // the widget's declared size — the source of the visual square.
      final iconButton = tester.widget<FlowinIconButton>(
        find.byType(FlowinIconButton),
      );
      expect(iconButton.size, FlowinButtonSize.xs);
    });

    testWidgets(
      'showFlowinActionSheet presents the sheet and '
      'popFlowinActionSheet dismisses it',
      (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) => FlowinButton.filled(
              onPressed: () => showFlowinActionSheet<void>(
                context: context,
                builder: (_) => FlowinActionSheet(title: 'Sheet'),
              ),
              label: 'Open',
            ),
          ),
        );

        expect(find.text('Sheet'), findsNothing);

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.text('Sheet'), findsOneWidget);

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        expect(find.text('Sheet'), findsNothing);
      },
    );

    testWidgets('forwards backgroundColor/constraints/clipBehavior overrides', (
      tester,
    ) async {
      const override = Color(0xFF123456);
      const constraints = BoxConstraints(maxWidth: 320);

      await tester.pumpApp(
        Builder(
          builder: (context) => FlowinButton.filled(
            onPressed: () => showFlowinActionSheet<void>(
              context: context,
              backgroundColor: override,
              constraints: constraints,
              clipBehavior: Clip.antiAlias,
              builder: (_) => FlowinActionSheet(title: 'Sheet'),
            ),
            label: 'Open',
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(sheet.backgroundColor, override);
      expect(sheet.constraints, constraints);
      expect(sheet.clipBehavior, Clip.antiAlias);
    });

    testWidgets('uses Flowin defaults when overrides are omitted', (
      tester,
    ) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => FlowinButton.filled(
            onPressed: () => showFlowinActionSheet<void>(
              context: context,
              builder: (_) => FlowinActionSheet(title: 'Sheet'),
            ),
            label: 'Open',
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(sheet.backgroundColor, Colors.transparent);
      // The default test viewport (800pt) is wider than the 480 clamp, so the
      // default constraints are the wide-viewport branch.
      expect(sheet.constraints, const BoxConstraints(maxWidth: 480));
      expect(sheet.clipBehavior, Clip.none);
    });
  });

  group('FlowinActionSheetHeader alignment', () {
    testWidgets('the title sits level with the close button', (tester) async {
      await tester.pumpApp(
        FlowinActionSheetHeader(title: 'Settings'),
      );

      // The close button's rendered box is its minimum tap target, which is
      // taller than the control drawn inside it — so it sets the row height.
      // Aligning the title to the bottom of that box dropped it half a tap
      // target below the glyph it should read as level with.
      final title = tester.getRect(find.text('Settings'));
      final close = tester.getRect(find.byType(FlowinIconButton));

      expect(title.center.dy, close.center.dy);
    });

    testWidgets('the icon sits level with the close button', (tester) async {
      await tester.pumpApp(
        FlowinActionSheetHeader(
          title: 'Settings',
          subtitle: 'A subtitle',
          icon: FDIcons.settings.toIcon(),
        ),
      );

      final icon = tester.getRect(find.byType(Icon).first);
      final close = tester.getRect(find.byType(FlowinIconButton));

      expect(icon.center.dy, close.center.dy);
    });
  });

  group('FlowinActionSheetHeader spacing', () {
    testWidgets('is unchanged when the close button is hidden', (
      tester,
    ) async {
      Future<(double, double)> metricsFor({required bool displayClose}) async {
        await tester.pumpApp(
          FlowinActionSheet(
            title: 'Descriptive title',
            subtitle: 'A subtitle',
            displayClose: displayClose,
            margin: EdgeInsets.zero,
          ),
        );
        final sheet = tester.getRect(find.byType(FlowinActionSheet));
        final title = tester.getRect(find.text('Descriptive title'));
        final subtitle = tester.getRect(find.text('A subtitle'));

        return (title.top - sheet.top, subtitle.top - title.bottom);
      }

      // The close button's box is a tap target inflated by VisualDensity. While
      // it set the row height, hiding it collapsed the header — costing the
      // sheet 32px and all but closing the title-to-subtitle gap.
      final withClose = await metricsFor(displayClose: true);
      final withoutClose = await metricsFor(displayClose: false);

      expect(withoutClose, withClose);
    });
  });

  group('FlowinActionSheetHeader close button', () {
    testWidgets('lays out at its natural size', (tester) async {
      await tester.pumpApp(
        FlowinActionSheet(title: 'Title', margin: EdgeInsets.zero),
      );

      // The bar reports a fixed height so the button's tap target cannot set
      // the header's shape — but the button still has to lay out at its own
      // size. Constraining it instead of the row squashed the tonal circle
      // down to the glyph.
      final button = tester.getRect(find.byType(FlowinIconButton));

      expect(button.height, button.width);
    });
  });

  group('showFlowinActionSheet keyboard inset', () {
    const screen = Size(400, 800);

    /// Presents a sheet with [inset] of the screen covered by the keyboard,
    /// and returns the sheet's rect.
    ///
    /// The inset is set on `tester.view` rather than by wrapping a
    /// [MediaQuery]: the sheet is a route, so it builds against the view's own
    /// MediaQuery and never sees one injected below the [MaterialApp].
    Future<Rect> sheetRect(WidgetTester tester, {required double inset}) async {
      tester.view.physicalSize = screen;
      tester.view.devicePixelRatio = 1.0;
      tester.view.viewInsets = FakeViewPadding(bottom: inset);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        MaterialApp(
          theme: FlowinTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showFlowinActionSheet<void>(
                  context: context,
                  builder: (_) => FlowinActionSheet(
                    title: 'Rename',
                    body: const SizedBox(height: 120),
                    footer: FlowinActionSheetFooter(
                      right: FlowinButton.filled(
                        onPressed: () {},
                        label: 'Save',
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      return tester.getRect(find.byType(FlowinActionSheet));
    }

    testWidgets('the sheet clears the keyboard instead of sitting behind it', (
      tester,
    ) async {
      // A real keyboard's height. showModalBottomSheet sizes its child against
      // the full screen and never reads viewInsets, so without the fix the
      // sheet's rect is identical with and without a keyboard — leaving the
      // footer actions underneath it.
      const keyboard = 336.0;

      final rect = await sheetRect(tester, inset: keyboard);

      expect(
        rect.bottom,
        lessThanOrEqualTo(screen.height - keyboard),
        reason: 'the sheet must sit entirely above the keyboard',
      );
    });

    testWidgets('the sheet is unmoved when no keyboard is open', (
      tester,
    ) async {
      // The lift must be exactly the covered height and nothing more, so a
      // sheet with no keyboard still rests against the bottom of the screen.
      final resting = await sheetRect(tester, inset: 0);
      expect(resting.bottom, closeTo(screen.height, 0.01));
    });

    testWidgets('a sheet taller than the remaining space overflows', (
      tester,
    ) async {
      // Documents the boundary of this fix rather than a desired behaviour.
      // The lift moves the card, it does not shrink it, so a body taller than
      // what the keyboard leaves still overflows. Callers with growable
      // bodies must make them scrollable — see showFlowinActionSheet's docs.
      tester.view.physicalSize = screen;
      tester.view.devicePixelRatio = 1.0;
      tester.view.viewInsets = const FakeViewPadding(bottom: 336);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: FlowinTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showFlowinActionSheet<void>(
                  context: context,
                  builder: (_) => const FlowinActionSheet(
                    title: 'Tall',
                    body: SizedBox(height: 500),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isA<FlutterError>(),
        reason:
            'if this stops throwing, the sheet learned to shrink or '
            'scroll — update the documented limit',
      );
    });

    testWidgets('the sheet lifts by exactly the covered height', (
      tester,
    ) async {
      const keyboard = 200.0;
      final resting = await sheetRect(tester, inset: 0);
      final lifted = await sheetRect(tester, inset: keyboard);

      expect(
        resting.bottom - lifted.bottom,
        closeTo(keyboard, 0.01),
        reason: 'over-lifting would leave a gap above the keyboard',
      );
      // The card keeps its size; only its position changes.
      expect(lifted.height, closeTo(resting.height, 0.01));
    });
  });

  group('FlowinActionSheetFooter', () {
    testWidgets('renders both left and right actions', (tester) async {
      await tester.pumpApp(
        FlowinActionSheetFooter(
          left: FlowinButton.text(onPressed: () {}, label: 'Cancel'),
          right: FlowinButton.filled(onPressed: () {}, label: 'Confirm'),
        ),
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders only the right action when left is null', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinActionSheetFooter(
          right: FlowinButton.filled(onPressed: () {}, label: 'Confirm'),
        ),
      );
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.byType(FlowinButton), findsOneWidget);
    });
  });

  group('popFlowinActionSheet', () {
    testWidgets('hands a result back to the awaiting caller', (tester) async {
      late BuildContext hostContext;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            hostContext = context;
            return const SizedBox.shrink();
          },
        ),
      );

      final pending = showFlowinActionSheet<bool>(
        context: hostContext,
        builder: (sheetContext) => FlowinButton.filled(
          onPressed: () => sheetContext.popFlowinActionSheet(true),
          label: 'Confirm',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Without a result parameter this resolves to null, and every
      // confirmation sheet in a consuming app silently reads as "cancelled".
      expect(await pending, isTrue);
    });

    testWidgets('resolves to null when popped with no result', (tester) async {
      late BuildContext hostContext;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            hostContext = context;
            return const SizedBox.shrink();
          },
        ),
      );

      final pending = showFlowinActionSheet<bool>(
        context: hostContext,
        builder: (sheetContext) => FlowinButton.text(
          onPressed: () => sheetContext.popFlowinActionSheet(),
          label: 'Cancel',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await pending, isNull);
    });
  });
}
