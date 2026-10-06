import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/core/theme/civic_theme.dart';
import 'package:janseva_mobile/features/notifications/screens/notifications_screen.dart';

void main() {
  testWidgets('NotificationsScreen AQIL Tests: Renders cleanly on 320px compact viewport without layout overflow',
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
        home: NotificationsScreen(state: state),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsOneWidget);
    expect(find.textContaining('Notifications & Alerts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('NotificationsScreen AQIL Tests: Renders cleanly under 1.5x dynamic font scale',
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
          child: NotificationsScreen(state: state),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('NotificationsScreen: Marking all as read updates state and UI',
      (WidgetTester tester) async {
    final state = JanSevaState();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await state.refreshGrievances();

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: NotificationsScreen(state: state),
      ),
    );

    await tester.pumpAndSettle();

    expect(state.unreadNotificationsCount, greaterThan(0));

    // Tap 'Mark all read' action button
    final markAllButton = find.text('Mark all read');
    expect(markAllButton, findsOneWidget);
    await tester.tap(markAllButton);
    await tester.pumpAndSettle();

    expect(state.unreadNotificationsCount, 0);
    expect(tester.takeException(), isNull);
  });
}
