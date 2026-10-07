import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/reporting/screens/quick_grievance_screen.dart';

void main() {
  group('QuickGrievanceScreen AQIL Tests', () {
    testWidgets('Renders 3-step quick grievance form cleanly on 320px compact viewport', (tester) async {
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
            home: QuickGrievanceScreen(state: state),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quick 3-Step Govt Grievance'), findsOneWidget);
      expect(find.text('Broken Pothole'), findsOneWidget);

      // Select 1-tap issue
      await tester.tap(find.text('Broken Pothole'));
      await tester.pumpAndSettle();

      // Verify routing card appeared
      expect(find.text('Step 2: AI Department Routing Preview'), findsOneWidget);
      expect(find.text('Urban Local Body (ULB 311)'), findsOneWidget);

      // Tap submit to government
      await tester.ensureVisible(find.text('Step 3: Dispatch to Government'));
      await tester.tap(find.text('Step 3: Dispatch to Government'));
      await tester.pumpAndSettle();

      // Verify receipt screen with official docket number
      expect(find.text('Grievance Dispatched to Government!'), findsOneWidget);
      expect(find.text('Return to Home'), findsOneWidget);
    });

    testWidgets('Renders Hindi language translations accurately', (tester) async {
      final state = JanSevaState();
      state.toggleLanguage(); // Switch to Hindi

      await tester.pumpWidget(
        MaterialApp(
          home: QuickGrievanceScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('त्वरित 3-चरणीय शिकायत दर्ज करें'), findsOneWidget);
      expect(find.text('सड़क पर गड्ढा'), findsOneWidget);
    });
  });
}
