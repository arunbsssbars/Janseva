import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/climate/screens/heat_resilience_screen.dart';

void main() {
  group('HeatResilienceScreen AQIL & Layout Tests', () {
    testWidgets('renders heatwave advisory and cooling centers', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: HeatResilienceScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Urban Heat & Climate Resilience'), findsOneWidget);
      expect(find.text('41.5°C'), findsOneWidget);
      expect(find.text('Dr. Ambedkar Community Cooling Shelter'), findsOneWidget);
      expect(find.text('Drinking Water'), findsWidgets);
      expect(find.text('Free ORS'), findsWidgets);
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
          home: const HeatResilienceScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('लू व शहरी जलवायु अनुकूलन'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
