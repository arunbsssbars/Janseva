import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/billing/screens/utility_dispute_screen.dart';

void main() {
  group('UtilityDisputeScreen AQIL & Form Submission Tests', () {
    testWidgets('submits new utility dispute and adds it to list', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: UtilityDisputeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Utility & Tax Dispute Redressal'), findsOneWidget);
      expect(find.text('DISP-2026-091'), findsOneWidget);

      // Enter details
      await tester.enterText(find.byKey(const Key('consumer_number_field')), 'PT-WRD01-9988');
      await tester.enterText(find.byKey(const Key('amount_field')), '5200');
      await tester.enterText(find.byKey(const Key('reason_field')), 'Double tax assessment on basement');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.byKey(const Key('submit_claim_btn')));
      await tester.pumpAndSettle();

      expect(find.textContaining('PT-WRD01-9988'), findsWidgets);
      expect(find.text('Under Verification'), findsOneWidget);
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
          home: const UtilityDisputeScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('नगरपालिका कर व बिल निवारण'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
