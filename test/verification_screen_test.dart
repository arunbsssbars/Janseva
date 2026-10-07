import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/verification/screens/verification_screen.dart';

void main() {
  group('CitizenVerificationScreen AQIL Tests', () {
    testWidgets('Renders properly on 320px compact mobile without layout overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      final state = JanSevaState();
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await state.refreshGrievances();

      final resolvedGrievance = state.grievances.first;

      await tester.pumpWidget(
        MaterialApp(
          home: CitizenVerificationScreen(
            grievance: resolvedGrievance,
            state: state,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Citizen Verification'), findsOneWidget);
      expect(find.text('Rate Resolution Quality'), findsOneWidget);
      expect(find.byType(IconButton), findsWidgets);
    });
  });
}
