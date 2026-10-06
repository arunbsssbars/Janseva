import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/reporting/screens/report_grievance_screen.dart';

void main() {
  group('ReportGrievanceScreen AQIL Tests', () {
    testWidgets('Renders all input fields and options at 320px compact width without overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      final state = JanSevaState();
      await tester.pumpWidget(
        MaterialApp(
          home: ReportGrievanceScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('File a Civic Grievance'), findsOneWidget);
      expect(find.text('Submit Grievance'), findsOneWidget);
    });

    testWidgets('Form validation triggers error message on empty submit', (tester) async {
      final state = JanSevaState();
      await tester.pumpWidget(
        MaterialApp(
          home: ReportGrievanceScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      final submitBtn = find.text('Submit Grievance');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please provide a title with at least 5 characters'), findsOneWidget);
    });
  });
}
