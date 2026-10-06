import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/feed/widgets/grievance_card.dart';
import 'package:janseva_mobile/features/tracking/screens/grievance_detail_screen.dart';

void main() {
  group('GrievanceCard and Detail AQIL Tests', () {
    testWidgets('GrievanceCard renders on 320px compact viewport without overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      final state = JanSevaState();
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await state.refreshGrievances();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: GrievanceCard(
                  grievance: state.grievances.first,
                  isHindi: false,
                  onTap: () {},
                  onUpvote: () {},
                  hasUpvoted: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(GrievanceCard), findsOneWidget);
    });

    testWidgets('GrievanceDetailScreen renders all sections cleanly', (tester) async {
      final state = JanSevaState();
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await state.refreshGrievances();
      final sampleId = state.grievances.first.id;

      await tester.pumpWidget(
        MaterialApp(
          home: GrievanceDetailScreen(
            grievanceId: sampleId,
            state: state,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(sampleId), findsOneWidget);
      expect(find.text('SLA Resolution Target'), findsOneWidget);
    });
  });
}
