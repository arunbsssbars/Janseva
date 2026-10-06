import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/theme/civic_theme.dart';
import 'package:janseva_mobile/features/officer/widgets/inspection_checklist_dialog.dart';

void main() {
  final testGrievance = Grievance(
    id: 'G-101',
    title: 'Water pipe leak on Market Road',
    description: 'Fresh water flooding the road',
    category: GrievanceCategory.waterSupply,
    priority: GrievancePriority.high,
    status: GrievanceStatus.inProgress,
    wardId: 'w-01',
    wardName: 'Civil Lines',
    citizenId: 'c-1',
    citizenName: 'Citizen',
    citizenPhone: '9876543210',
    latitude: 28.6139,
    longitude: 77.2090,
    address: 'Near Shop 12',
    landmark: 'Behind bus stand',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    updatedAt: DateTime.now(),
    slaDeadline: DateTime.now().add(const Duration(hours: 12)),
  );

  testWidgets('InspectionChecklistDialog AQIL Tests: Renders properly on 320px compact viewport without layout overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: Scaffold(
          body: InspectionChecklistDialog(
            grievance: testGrievance,
            isHindi: false,
            onAuditApproved: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(InspectionChecklistDialog), findsOneWidget);
    expect(find.text('Field Inspection Audit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('InspectionChecklistDialog: Blocks submission with error message if checklist is incomplete',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: Scaffold(
          body: InspectionChecklistDialog(
            grievance: testGrievance,
            isHindi: false,
            onAuditApproved: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap submit directly without checking boxes or entering crew ID
    await tester.tap(find.text('Approve & Mark Resolved'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Please complete all audit items'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
