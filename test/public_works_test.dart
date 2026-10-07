import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/public_works/screens/public_works_screen.dart';

void main() {
  group('PublicWorksScreen AQIL & Social Audit Tests', () {
    testWidgets('renders budget scorecard and project list cleanly on standard viewport',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: PublicWorksScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header and Budget Card
      expect(find.text('Public Works & Capital Budget'), findsOneWidget);
      expect(find.text('CAPITAL WORKS BUDGET'), findsOneWidget);
      expect(find.text('Sanctioned Budget'), findsOneWidget);
      expect(find.text('Disbursed / Spent'), findsOneWidget);

      // Verify project cards
      expect(find.text('Stormwater Culvert Deepening & Flood Abatement'), findsOneWidget);
      expect(find.text('Smart LED Grid & Sensorised Solar Illumination'), findsOneWidget);

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('submits citizen social audit successfully', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: PublicWorksScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Find first audit button
      final auditBtn = find.byKey(const Key('audit_btn_PW-2026-081'));
      expect(auditBtn, findsOneWidget);
      await tester.tap(auditBtn);
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Citizen Social Audit'), findsOneWidget);
      expect(find.text('RATE EXECUTION QUALITY & IMPACT'), findsOneWidget);

      // Tap submit audit
      final submitBtn = find.byKey(const Key('submit_audit_btn'));
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify SnackBar confirmation
      expect(find.text('Audit review verified and registered to public ledger!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on compact mobile 320px with 1.5x font scale without overflow',
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
          home: const PublicWorksScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Public Works & Capital Budget'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
