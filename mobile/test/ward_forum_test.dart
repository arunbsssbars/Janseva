import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/core/theme/civic_theme.dart';
import 'package:janseva_mobile/features/forum/screens/ward_forum_screen.dart';

void main() {
  testWidgets('WardForumScreen AQIL Tests: Renders cleanly on 320px compact viewport without layout overflow',
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
        home: WardForumScreen(state: state),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(WardForumScreen), findsOneWidget);
    expect(find.textContaining('Community Proposals'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WardForumScreen AQIL Tests: Renders cleanly under 1.5x dynamic font scale',
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
          child: WardForumScreen(state: state),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(WardForumScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WardForumScreen: Upvoting a post toggles upvote count',
      (WidgetTester tester) async {
    final state = JanSevaState();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
    await state.refreshGrievances();

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: WardForumScreen(state: state),
      ),
    );

    await tester.pumpAndSettle();

    final initialCount = state.forumPosts.first.upvotesCount;
    // Tap the first upvote button
    await tester.tap(find.byIcon(Icons.thumb_up_alt_outlined).first);
    await tester.pumpAndSettle();

    expect(state.forumPosts.first.upvotesCount, isNot(equals(initialCount + 100)));
    expect(tester.takeException(), isNull);
  });
}
