import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/air_quality/screens/air_quality_screen.dart';
import 'package:janseva_mobile/features/air_quality/models/aqi_station.dart';
import 'package:janseva_mobile/features/air_quality/services/aqi_service.dart';

void main() {
  group('Air Quality & AQI Monitoring Tests', () {
    test('AqiStation models and advisory logic calculate correct categories', () {
      final stations = AqiService.getLiveStations();
      expect(stations.isNotEmpty, isTrue);

      final severe = stations.firstWhere((s) => s.ward.contains('Industrial'));
      expect(severe.category, equals(AqiCategory.severe));
      expect(severe.advisoryEn.contains('Emergency alert'), isTrue);
      expect(severe.advisoryHi.contains('आपातकालीन चेतावनी'), isTrue);

      final good = stations.firstWhere((s) => s.ward.contains('Model Town'));
      expect(good.category, equals(AqiCategory.good));
      expect(good.advisoryEn.contains('Air quality is satisfactory'), isTrue);
    });

    testWidgets('AirQualityScreen renders properly across viewports with zero overflow', (tester) async {
      // Test compact viewport 320x640 with 1.5x font scale
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
            home: AirQualityScreen(isHindi: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Air Quality Index (AQI)'), findsOneWidget);
      expect(find.text('Live Ward Air Monitoring'), findsOneWidget);
      expect(find.text('Civil Lines Central Monitoring Tower'), findsOneWidget);
      expect(find.text('Industrial Zone Smog Sensor #4'), findsOneWidget);

      // Verify filtering
      await tester.ensureVisible(find.text('Ward 1'));
      await tester.tap(find.text('Ward 1'));
      await tester.pumpAndSettle();
      expect(find.text('Civil Lines Central Monitoring Tower'), findsOneWidget);
      expect(find.text('Industrial Zone Smog Sensor #4'), findsNothing);
    });

    testWidgets('AirQualityScreen Hindi translation renders properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AirQualityScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('वायु गुणवत्ता सूचकांक (AQI)'), findsOneWidget);
      expect(find.text('लाइव वार्ड वायु मॉनिटरिंग'), findsOneWidget);
      expect(find.text('सभी वार्ड'), findsOneWidget);
    });
  });
}
