import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/emergency/screens/emergency_hub_screen.dart';

void main() {
  group('EmergencyHubScreen AQIL Tests', () {
    testWidgets('Renders all emergency hotlines and SOS buttons on 320px compact viewport', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      final state = JanSevaState();
      await tester.pumpWidget(
        MaterialApp(
          home: EmergencyHubScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('National Emergency'), findsOneWidget);
      expect(find.text('112'), findsOneWidget);
      expect(find.text('Rapid Hazard Dispatch (1-Tap SOS)'), findsOneWidget);
    });
  });
}
