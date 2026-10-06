import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/services/route_optimizer.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/officer/screens/inspection_route_screen.dart';

void main() {
  group('InspectionRouteOptimizer & Screen AQIL Tests', () {
    test('optimizes route and calculates haversine distance correctly', () async {
      final state = JanSevaState();
      await state.refreshGrievances();
      final result = InspectionRouteOptimizer.optimizeRoute(
        officerLat: 28.6738,
        officerLon: 77.2185,
        grievances: state.grievances,
      );

      expect(result.waypoints.isNotEmpty, isTrue);
      expect(result.totalDistanceKm, greaterThan(0.0));
      expect(result.estimatedTotalMinutes, greaterThan(0));

      // Verify sequence order is 1-indexed and contiguous
      for (int i = 0; i < result.waypoints.length; i++) {
        expect(result.waypoints[i].sequenceOrder, equals(i + 1));
      }
    });

    testWidgets('InspectionRouteScreen renders cleanly on 320px compact viewport with 1.5x font scale',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final state = JanSevaState();
      await state.refreshGrievances();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: InspectionRouteScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Officer Inspection Route Planner'), findsOneWidget);
      expect(find.text('OPTIMIZED MANIFEST'), findsOneWidget);
      expect(find.text('ORDERED INSPECTION SEQUENCE'), findsOneWidget);

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    });
  });
}
