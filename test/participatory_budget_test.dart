import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/budget/screens/participatory_budget_screen.dart';

void main() {
  group('ParticipatoryBudgetScreen AQIL & Voting Tests', () {
    testWidgets('renders participatory budget proposals and toggles vote',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ParticipatoryBudgetScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participatory Ward Budget'), findsOneWidget);
      expect(find.text('₹50 Lakhs Pool'), findsOneWidget);
      expect(find.text('Support Proposal'), findsNWidgets(2));
      expect(find.text('Voted'), findsOneWidget);

      // Tap vote on PBP-WRD1-01
      await tester.tap(find.byKey(const Key('vote_btn_PBP-WRD1-01')));
      await tester.pumpAndSettle();

      expect(find.text('Voted'), findsNWidgets(2));
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
          home: const ParticipatoryBudgetScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('नागरिक सहभागिता बजट मतदान'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
