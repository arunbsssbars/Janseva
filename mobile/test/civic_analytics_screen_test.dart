import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/analytics/screens/civic_analytics_screen.dart';

void main() {
  group('CivicAnalyticsScreen AQIL Tests', () {
    testWidgets('Renders properly on 320px compact viewport without layout overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      final state = JanSevaState();
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await state.refreshGrievances();

      await tester.pumpWidget(
        MaterialApp(
          home: CivicAnalyticsScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Municipal Efficiency Scorecard'), findsOneWidget);
      expect(find.text('Total Reports'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
    });
  });
}
