import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/schemes/screens/schemes_directory_screen.dart';

void main() {
  group('SchemesDirectoryScreen AQIL Tests', () {
    testWidgets('Renders all welfare schemes and eligibility filters on 320px compact viewport', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      final state = JanSevaState();
      await tester.pumpWidget(
        MaterialApp(
          home: SchemesDirectoryScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Welfare Schemes'), findsOneWidget);
      expect(find.text('Ayushman Bharat - PM-JAY'), findsOneWidget);
      expect(find.text('Eligibility Checker (Annual Income)'), findsOneWidget);
    });
  });
}
