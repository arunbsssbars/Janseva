import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/reporting/screens/silent_issue_audit_screen.dart';

void main() {
  group('SilentIssueAuditScreen AQIL Tests', () {
    testWidgets('Renders silent issue audit on 320px compact viewport without overflow', (tester) async {
      tester.view.physicalSize = const Size(320 * 2, 640 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final state = JanSevaState();

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(1.5),
          ),
          child: MaterialApp(
            home: SilentIssueAuditScreen(state: state),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Silent Issue Civic Hunter'), findsOneWidget);
      expect(find.text('Silent Water Pressure Drop in Sector 4'), findsOneWidget);

      // Corroborate first item
      final confirmBtn = find.text('I Confirm This').first;
      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('Flags new unreported civic spot correctly', (tester) async {
      final state = JanSevaState();

      await tester.pumpWidget(
        MaterialApp(
          home: SilentIssueAuditScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Leaking underground valve on Park Street');
      await tester.tap(find.text('Flag Defect'));
      await tester.pumpAndSettle();

      expect(find.text('Leaking underground valve on Park Street'), findsOneWidget);
    });
  });
}
