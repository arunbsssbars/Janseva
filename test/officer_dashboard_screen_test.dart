import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/officer/screens/officer_dashboard_screen.dart';

void main() {
  group('OfficerDashboardScreen AQIL Tests', () {
    testWidgets('Renders KPI tiles and officer controls on 320px compact viewport without overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      final state = JanSevaState();
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await state.switchRole(UserRole.wardOfficer);
      await state.refreshGrievances();

      await tester.pumpWidget(
        MaterialApp(
          home: OfficerDashboardScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Officer Workspace'), findsOneWidget);
      expect(find.text('Pending Triage'), findsOneWidget);
      expect(find.text('In Progress'), findsWidgets);
    });
  });
}
