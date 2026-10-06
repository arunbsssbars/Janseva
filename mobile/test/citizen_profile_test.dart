import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/core/theme/civic_theme.dart';
import 'package:janseva_mobile/features/profile/screens/citizen_profile_screen.dart';

void main() {
  testWidgets('CitizenProfileScreen AQIL Tests: Renders properly on 320px compact viewport without layout overflow',
      (WidgetTester tester) async {
    final state = JanSevaState();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await state.refreshGrievances();

    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: CitizenProfileScreen(state: state),
      ),
    );

    await tester.pumpAndSettle();

    // Verify user information and karma tier render without error
    expect(find.text(state.currentUser.name), findsOneWidget);
    expect(find.byType(CitizenProfileScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CitizenProfileScreen AQIL Tests: Renders cleanly under 1.5x dynamic font scale',
      (WidgetTester tester) async {
    final state = JanSevaState();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await state.refreshGrievances();

    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: CitizenProfileScreen(state: state),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CitizenProfileScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
