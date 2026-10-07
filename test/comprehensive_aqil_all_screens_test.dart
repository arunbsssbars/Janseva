import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';
import 'package:janseva_mobile/core/theme/civic_theme.dart';
import 'package:janseva_mobile/features/air_quality/screens/air_quality_screen.dart';
import 'package:janseva_mobile/features/analytics/screens/civic_analytics_screen.dart';
import 'package:janseva_mobile/features/billing/screens/utility_dispute_screen.dart';
import 'package:janseva_mobile/features/budget/screens/participatory_budget_screen.dart';
import 'package:janseva_mobile/features/climate/screens/heat_resilience_screen.dart';
import 'package:janseva_mobile/features/community/screens/civic_drives_screen.dart';
import 'package:janseva_mobile/features/disaster/screens/flood_preparedness_screen.dart';
import 'package:janseva_mobile/features/emergency/screens/emergency_hub_screen.dart';
import 'package:janseva_mobile/features/forum/screens/ward_forum_screen.dart';
import 'package:janseva_mobile/features/map/screens/ward_map_screen.dart';
import 'package:janseva_mobile/features/notices/screens/ward_notices_screen.dart';
import 'package:janseva_mobile/features/notifications/screens/notifications_screen.dart';
import 'package:janseva_mobile/features/officer/screens/inspection_route_screen.dart';
import 'package:janseva_mobile/features/officer/screens/officer_dashboard_screen.dart';
import 'package:janseva_mobile/features/parking/screens/smart_parking_screen.dart';
import 'package:janseva_mobile/features/profile/screens/citizen_profile_screen.dart';
import 'package:janseva_mobile/features/profile/screens/identity_verification_screen.dart';
import 'package:janseva_mobile/features/public_works/screens/public_works_screen.dart';
import 'package:janseva_mobile/features/reporting/screens/quick_grievance_screen.dart';
import 'package:janseva_mobile/features/reporting/screens/report_grievance_screen.dart';
import 'package:janseva_mobile/features/reporting/screens/silent_issue_audit_screen.dart';
import 'package:janseva_mobile/features/rti/screens/rti_portal_screen.dart';
import 'package:janseva_mobile/features/schemes/screens/schemes_directory_screen.dart';
import 'package:janseva_mobile/features/telemetry/screens/iot_telemetry_screen.dart';
import 'package:janseva_mobile/features/tracking/screens/grievance_detail_screen.dart';
import 'package:janseva_mobile/features/vending/screens/street_vendor_screen.dart';
import 'package:janseva_mobile/features/verification/screens/verification_screen.dart';
import 'package:janseva_mobile/features/veterinary/screens/animal_rescue_screen.dart';
import 'package:janseva_mobile/features/water_quality/screens/water_quality_screen.dart';
import 'package:janseva_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final viewports = [
    const Size(320, 568),  // Compact Mobile (iPhone SE / older Android)
    const Size(393, 852),  // Standard Mobile (iPhone 15 / Pixel 8)
    const Size(412, 915),  // Large Mobile (Galaxy S24 / Pixel Pro)
    const Size(800, 1280), // Tablet Portrait / Kiosk
    const Size(1280, 800), // Desktop / Landscape Tablet
  ];

  final fontScales = [1.0, 1.3, 1.5];

  late JanSevaState testState;

  setUp(() async {
    testState = JanSevaState();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  });

  Future<void> pumpAndVerifyScreen({
    required WidgetTester tester,
    required Widget screen,
    required Size viewport,
    required double fontScale,
    String? testName,
  }) async {
    tester.view.physicalSize = Size(viewport.width * 2, viewport.height * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: CivicTheme.lightTheme,
        home: MediaQuery(
          data: MediaQueryData(
            size: viewport,
            textScaler: TextScaler.linear(fontScale),
          ),
          child: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final exception = tester.takeException();
    if (exception != null) {
      if (exception is FlutterError) {
        for (final diag in exception.diagnostics) {
          debugPrint('DIAG: ${diag.toString()}');
        }
      } else {
        debugPrint('AQIL EXCEPTION: $exception');
      }
    }
    expect(
      exception,
      isNull,
      reason: 'Failed on $testName at $viewport with ${fontScale}x font scale',
    );
  }

  group('Comprehensive AQIL All-Screen Matrix Suite (30 Screens)', () {
    testWidgets('1. JanSevaHomeScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      await testState.refreshGrievances();
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: JanSevaHomeScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'JanSevaHomeScreen',
          );
        }
      }
    });

    testWidgets('2. QuickGrievanceScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: QuickGrievanceScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'QuickGrievanceScreen',
          );
        }
      }
    });

    testWidgets('3. SilentIssueAuditScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: SilentIssueAuditScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'SilentIssueAuditScreen',
          );
        }
      }
    });

    testWidgets('4. ReportGrievanceScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: ReportGrievanceScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'ReportGrievanceScreen',
          );
        }
      }
    });

    testWidgets('5. GrievanceDetailScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      await testState.refreshGrievances();
      final gId = testState.grievances.first.id;
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: GrievanceDetailScreen(grievanceId: gId, state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'GrievanceDetailScreen',
          );
        }
      }
    });

    testWidgets('6. CitizenProfileScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: CitizenProfileScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'CitizenProfileScreen',
          );
        }
      }
    });

    testWidgets('7. IdentityVerificationScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const IdentityVerificationScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'IdentityVerificationScreen',
          );
        }
      }
    });

    testWidgets('8. CitizenVerificationScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      await testState.refreshGrievances();
      final g = testState.grievances.first;
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: CitizenVerificationScreen(grievance: g, state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'CitizenVerificationScreen',
          );
        }
      }
    });

    testWidgets('9. OfficerDashboardScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: OfficerDashboardScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'OfficerDashboardScreen',
          );
        }
      }
    });

    testWidgets('10. InspectionRouteScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: InspectionRouteScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'InspectionRouteScreen',
          );
        }
      }
    });

    testWidgets('11. EmergencyHubScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: EmergencyHubScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'EmergencyHubScreen',
          );
        }
      }
    });

    testWidgets('12. WardMapScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: WardMapScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'WardMapScreen',
          );
        }
      }
    });

    testWidgets('13. WardForumScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: WardForumScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'WardForumScreen',
          );
        }
      }
    });

    testWidgets('14. WardNoticesScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: WardNoticesScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'WardNoticesScreen',
          );
        }
      }
    });

    testWidgets('15. NotificationsScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: NotificationsScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'NotificationsScreen',
          );
        }
      }
    });

    testWidgets('16. CivicAnalyticsScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: CivicAnalyticsScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'CivicAnalyticsScreen',
          );
        }
      }
    });

    testWidgets('17. PublicWorksScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const PublicWorksScreen(),
            viewport: vp,
            fontScale: scale,
            testName: 'PublicWorksScreen',
          );
        }
      }
    });

    testWidgets('18. SchemesDirectoryScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: SchemesDirectoryScreen(state: testState),
            viewport: vp,
            fontScale: scale,
            testName: 'SchemesDirectoryScreen',
          );
        }
      }
    });

    testWidgets('19. RtiPortalScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const RtiPortalScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'RtiPortalScreen',
          );
        }
      }
    });

    testWidgets('20. CivicDrivesScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const CivicDrivesScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'CivicDrivesScreen',
          );
        }
      }
    });

    testWidgets('21. UtilityDisputeScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const UtilityDisputeScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'UtilityDisputeScreen',
          );
        }
      }
    });

    testWidgets('22. AnimalRescueScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const AnimalRescueScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'AnimalRescueScreen',
          );
        }
      }
    });

    testWidgets('23. HeatResilienceScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const HeatResilienceScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'HeatResilienceScreen',
          );
        }
      }
    });

    testWidgets('24. ParticipatoryBudgetScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const ParticipatoryBudgetScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'ParticipatoryBudgetScreen',
          );
        }
      }
    });

    testWidgets('25. StreetVendorScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const StreetVendorScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'StreetVendorScreen',
          );
        }
      }
    });

    testWidgets('26. IotTelemetryScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const IotTelemetryScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'IotTelemetryScreen',
          );
        }
      }
    });

    testWidgets('27. FloodPreparednessScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const FloodPreparednessScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'FloodPreparednessScreen',
          );
        }
      }
    });

    testWidgets('28. AirQualityScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const AirQualityScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'AirQualityScreen',
          );
        }
      }
    });

    testWidgets('29. SmartParkingScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const SmartParkingScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'SmartParkingScreen',
          );
        }
      }
    });

    testWidgets('30. WaterQualityScreen: 5 Viewports & 1.5x Dynamic Font Scaling', (tester) async {
      for (final vp in viewports) {
        for (final scale in fontScales) {
          await pumpAndVerifyScreen(
            tester: tester,
            screen: const WaterQualityScreen(isHindi: false),
            viewport: vp,
            fontScale: scale,
            testName: 'WaterQualityScreen',
          );
        }
      }
    });
  });
}
