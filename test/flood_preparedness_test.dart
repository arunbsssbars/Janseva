import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/disaster/screens/flood_preparedness_screen.dart';

void main() {
  group('FloodPreparednessScreen AQIL & Checklist Tests', () {
    testWidgets('renders flood checklist items and toggles completion', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: FloodPreparednessScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Monsoon Flood Preparedness'), findsOneWidget);
      expect(find.text('Clear Compound Stormwater Drain Gratings'), findsOneWidget);
      expect(find.text('50% Ready'), findsOneWidget);

      // Toggle FLD-02 checkbox
      await tester.tap(find.byKey(const Key('check_FLD-02')));
      await tester.pumpAndSettle();

      expect(find.text('75% Ready'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on 320px compact viewport with 1.5x font scale',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: const FloodPreparednessScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('मानसून बाढ़ आपदा तैयारी'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
