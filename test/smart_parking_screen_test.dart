import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/parking/screens/smart_parking_screen.dart';
import 'package:janseva_mobile/features/parking/services/parking_service.dart';

void main() {
  group('Smart Municipal Parking Tests', () {
    test('ParkingService provides valid spots and calculations', () {
      final spots = ParkingService.getLiveParkingSpots();
      expect(spots.length, greaterThanOrEqualTo(4));

      final first = spots.first;
      expect(first.availableSlots, equals(first.totalSlots - first.occupiedSlots));
      expect(first.isHighDemand, isTrue);
    });

    testWidgets('SmartParkingScreen renders across 320px viewport without overflow', (tester) async {
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
            home: SmartParkingScreen(isHindi: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Municipal Parking'), findsOneWidget);
      expect(find.text('Metro Multi-Level Automated Parking'), findsOneWidget);

      // Filter by EV only
      await tester.ensureVisible(find.text('EV Charging Only'));
      await tester.tap(find.text('EV Charging Only'));
      await tester.pumpAndSettle();

      expect(find.text('Metro Multi-Level Automated Parking'), findsOneWidget);
      expect(find.text('Gandhi Nagar Central Market Plaza'), findsNothing);
    });

    testWidgets('SmartParkingScreen Hindi translation renders cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SmartParkingScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('स्मार्ट म्युनिसिपल पार्किंग'), findsOneWidget);
      expect(find.text('लाइव स्लॉट उपलब्धता'), findsOneWidget);
    });
  });
}
