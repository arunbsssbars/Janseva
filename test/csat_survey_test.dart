import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/models/resolution_csat.dart';
import 'package:janseva_mobile/features/verification/widgets/csat_breakdown_card.dart';

void main() {
  group('Resolution CSAT Model & Widget AQIL Tests', () {
    test('ResolutionCsat model calculates average score and serializes correctly', () {
      final csat = ResolutionCsat(
        grievanceId: 'G-2026-001',
        overallRating: 4,
        speedRating: 5,
        qualityRating: 4,
        officerBehaviorRating: 5,
        wouldRecommend: true,
        comments: 'Prompt resolution of streetlight pole.',
        submittedAt: DateTime(2026, 3, 1),
      );

      expect(csat.averageScore, equals(4.5));
      final json = csat.toJson();
      expect(json['grievanceId'], equals('G-2026-001'));
      expect(json['wouldRecommend'], isTrue);

      final revived = ResolutionCsat.fromJson(json);
      expect(revived.averageScore, equals(4.5));
      expect(revived.comments, equals('Prompt resolution of streetlight pole.'));
    });

    testWidgets('CsatBreakdownCard renders cleanly on 320px compact viewport without layout overflow',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      int speed = 4;
      int quality = 5;
      int behavior = 4;
      bool recommend = true;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: SingleChildScrollView(
              child: CsatBreakdownCard(
                speedRating: speed,
                qualityRating: quality,
                behaviorRating: behavior,
                wouldRecommend: recommend,
                onSpeedChanged: (val) => speed = val,
                onQualityChanged: (val) => quality = val,
                onBehaviorChanged: (val) => behavior = val,
                onRecommendChanged: (val) => recommend = val,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Detailed Resolution CSAT Scorecard'), findsOneWidget);
      expect(find.text('Resolution Speed'), findsOneWidget);
      expect(find.text('Workmanship & Quality'), findsOneWidget);
      expect(find.text('Officer Courtesy'), findsOneWidget);
      expect(find.text('Recommend service delivery?'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}
