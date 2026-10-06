import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/veterinary/screens/animal_rescue_screen.dart';

void main() {
  group('AnimalRescueScreen AQIL & Emergency Triage Tests', () {
    testWidgets('dispatches animal ambulance and updates rescue list', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: AnimalRescueScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Stray Animal & Veterinary Rescue'), findsOneWidget);
      expect(find.text('VET-2026-031 • Dog'), findsOneWidget);

      // Enter rescue details
      await tester.enterText(find.byKey(const Key('animal_location_field')), 'Behind Central Park Pond');
      await tester.enterText(find.byKey(const Key('animal_contact_field')), '+91 99887 76655');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dispatch_rescue_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Behind Central Park Pond'), findsOneWidget);
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
          home: const AnimalRescueScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('पशु बचाव व चिकित्सा आपातकाल'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
