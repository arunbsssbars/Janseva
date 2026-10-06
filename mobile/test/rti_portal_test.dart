import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/rti/screens/rti_portal_screen.dart';

void main() {
  group('RtiPortalScreen AQIL & Statutory Tracking Tests', () {
    testWidgets('renders filings list cleanly on standard viewport', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: RtiPortalScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Right to Information (RTI)'), findsOneWidget);
      expect(find.text('My RTI Filings'), findsOneWidget);
      expect(find.text('File New Application'), findsOneWidget);
      expect(find.text('Expenditure & Contractor Details for Ward 1 Culvert Repair'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('switches to File Application tab and validates fields', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: RtiPortalScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap tab 2
      await tester.tap(find.text('File New Application'));
      await tester.pumpAndSettle();

      expect(find.text('Target Municipal Department'), findsOneWidget);
      expect(find.text('Submit Statutory RTI Application'), findsOneWidget);

      // Attempt submit without fields
      await tester.ensureVisible(find.byKey(const Key('submit_rti_btn')));
      await tester.tap(find.byKey(const Key('submit_rti_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Please specify subject'), findsOneWidget);
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
          home: const RtiPortalScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Right to Information (RTI)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
