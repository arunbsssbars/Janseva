import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/telemetry/screens/iot_telemetry_screen.dart';

void main() {
  group('IotTelemetryScreen AQIL & Layout Tests', () {
    testWidgets('renders air quality and water sump telemetry nodes', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: IotTelemetryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('IoT Sensors & Environmental Telemetry'), findsOneWidget);
      expect(find.text('Civil Lines Central Crossroad'), findsOneWidget);
      expect(find.text('Civil Lines Overhead Tank A'), findsOneWidget);
      expect(find.text('AQI 142 • Poor'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on 320px compact viewport with 1.5x font scale',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: const IotTelemetryScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('आईओटी सेंसर टेलीमेट्री व निगरानी'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
