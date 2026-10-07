import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/features/notices/screens/ward_notices_screen.dart';

void main() {
  group('WardNoticesScreen AQIL Tests', () {
    testWidgets('Renders properly on 320px compact viewport without layout overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      final state = JanSevaState();
      await tester.pumpWidget(
        MaterialApp(
          home: WardNoticesScreen(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ward Notices & Bulletins'), findsOneWidget);
      expect(find.text('Water Supply Shutdown for Booster Maintenance'), findsOneWidget);
    });
  });
}
