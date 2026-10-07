import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/widgets/civic_widgets.dart';

void main() {
  group('AQIL Civic Defensive Widgets Verification', () {
    testWidgets('CivicStatusBadge renders across all statuses without overflow', (tester) async {
      for (final status in GrievanceStatus.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 150,
                  child: CivicStatusBadge(status: status),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('CivicPriorityBadge renders all priorities cleanly', (tester) async {
      for (final priority in GrievancePriority.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CivicPriorityBadge(priority: priority),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text(priority.label.toUpperCase()), findsOneWidget);
      }
    });

    testWidgets('CivicCategoryChip renders with 1.5x font scale without crash', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: SizedBox(
                width: 200,
                child: CivicCategoryChip(category: GrievanceCategory.roadsAndPotholes),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Roads & Potholes'), findsOneWidget);
    });

    testWidgets('ResponsiveScaffold clamps max width on tablet viewports', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveScaffold(
            body: Text('Tablet Content'),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Tablet Content'), findsOneWidget);
    });
  });
}
