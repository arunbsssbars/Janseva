import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/water_quality/screens/water_quality_screen.dart';
import 'package:janseva_mobile/features/water_quality/models/water_quality_node.dart';
import 'package:janseva_mobile/features/water_quality/services/water_quality_service.dart';

void main() {
  group('Water Quality Monitoring Tests', () {
    test('WaterQualityNode calculates safety statuses accurately', () {
      final nodes = WaterQualityService.getLiveNodes();
      expect(nodes.length, greaterThanOrEqualTo(4));

      final safeNode = nodes.firstWhere((n) => n.id == 'WTR-01');
      expect(safeNode.safetyStatus, equals(WaterSafetyStatus.potable));

      final alertNode = nodes.firstWhere((n) => n.id == 'WTR-03');
      expect(alertNode.safetyStatus, equals(WaterSafetyStatus.nonPotableAlert));
    });

    testWidgets('WaterQualityScreen renders across 320px viewport without overflow', (tester) async {
      tester.view.physicalSize = const Size(320 * 2, 640 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(1.5),
          ),
          child: MaterialApp(
            home: WaterQualityScreen(isHindi: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Drinking Water Quality'), findsOneWidget);
      expect(find.text('Civil Lines Overhead Reservoir Tank #2'), findsOneWidget);

      // Filter by Ward 1
      await tester.ensureVisible(find.text('Ward 1'));
      await tester.tap(find.text('Ward 1'));
      await tester.pumpAndSettle();

      expect(find.text('Civil Lines Overhead Reservoir Tank #2'), findsOneWidget);
      expect(find.text('Gandhi Nagar Community Booster Station'), findsNothing);
    });

    testWidgets('WaterQualityScreen Hindi translation renders cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WaterQualityScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('पेयजल गुणवत्ता मॉनिटरिंग'), findsOneWidget);
      expect(find.text('लाइव जल परीक्षण नोड्स'), findsOneWidget);
    });
  });
}
