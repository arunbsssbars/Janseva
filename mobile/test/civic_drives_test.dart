import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/community/screens/civic_drives_screen.dart';

void main() {
  group('CivicDrivesScreen AQIL & Interaction Tests', () {
    testWidgets('renders civic drives and handles RSVP toggle', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: CivicDrivesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Civic Volunteer Drives'), findsOneWidget);
      expect(find.text('Ward 14 Mega Swachhata Shramdaan'), findsOneWidget);
      expect(find.text('Registered'), findsOneWidget);
      expect(find.text('Join Drive'), findsOneWidget);

      // Tap join drive on DRV-102
      await tester.tap(find.byKey(const Key('rsvp_btn_DRV-102')));
      await tester.pumpAndSettle();

      // Now both should be registered
      expect(find.text('Registered'), findsNWidgets(2));

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
          home: const CivicDrivesScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('नागरिक स्वयंसेवक अभियान'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
