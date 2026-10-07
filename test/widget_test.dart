import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/main.dart';

void main() {
  testWidgets('JanSeva Smoke and Navigation Test across Viewports', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    final state = JanSevaState();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await state.refreshGrievances();

    await tester.pumpWidget(JanSeva(initialState: state));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('JanSeva'), findsOneWidget);
    expect(find.text('Citizen Grievance Portal'), findsOneWidget);

    // Switch to Analytics tab
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Municipal Efficiency Scorecard'), findsOneWidget);

    // Switch to Emergency tab
    await tester.tap(find.byIcon(Icons.emergency_outlined));
    await tester.pumpAndSettle();
    expect(find.text('National Emergency'), findsOneWidget);

    // Switch to Schemes tab
    await tester.tap(find.byIcon(Icons.assured_workload_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Welfare Schemes'), findsOneWidget);

    // Switch to Notices tab
    await tester.tap(find.byIcon(Icons.campaign_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Ward Notices & Bulletins'), findsOneWidget);
  });
}
