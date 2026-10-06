import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/vending/screens/street_vendor_screen.dart';

void main() {
  group('StreetVendorScreen AQIL & Layout Tests', () {
    testWidgets('renders vendor certificate and allocated zones', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: StreetVendorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Street Vendor & Vending Zones'), findsOneWidget);
      expect(find.text('Radhe Shyam Gupt'), findsOneWidget);
      expect(find.text('North Market Pedestrian Vending Zone'), findsOneWidget);
      expect(find.text('Active Valid'), findsOneWidget);
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
          home: const StreetVendorScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('स्ट्रीट वेंडर व वेंडिंग ज़ोन'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
