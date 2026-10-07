import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/services/govt_machinery_registry.dart';
import 'package:janseva_mobile/features/statutory/screens/govt_machinery_hub_screen.dart';

void main() {
  group('GovtMachineryRegistry 20 Real-World Civic Cases Integrity', () {
    test('getAllCases returns exactly 20 comprehensive civic cases', () {
      final cases = GovtMachineryRegistry.getAllCases();
      expect(cases.length, 20);

      // Verify continuous numbering 1 to 20
      for (int i = 0; i < 20; i++) {
        expect(cases[i].caseNumber, i + 1);
        expect(cases[i].titleEn.isNotEmpty, isTrue);
        expect(cases[i].titleHi.isNotEmpty, isTrue);
        expect(cases[i].statutoryAct.isNotEmpty, isTrue);
        expect(cases[i].authorityEn.isNotEmpty, isTrue);
        expect(cases[i].authorityHi.isNotEmpty, isTrue);
        expect(cases[i].summaryEn.isNotEmpty, isTrue);
        expect(cases[i].summaryHi.isNotEmpty, isTrue);
        expect(cases[i].penaltyOrReliefEn.isNotEmpty, isTrue);
        expect(cases[i].penaltyOrReliefHi.isNotEmpty, isTrue);
      }
    });

    test('All 20 petition generators produce detailed statutory legal text', () {
      final cases = GovtMachineryRegistry.getAllCases();

      for (final item in cases) {
        final petition = item.petitionGenerator();
        expect(petition.isNotEmpty, isTrue);
        expect(
          petition.length > 80,
          isTrue,
          reason: 'Case #${item.caseNumber} petition text was too short: $petition',
        );
      }
    });

    test('Case 1: PWD Road DLP has valid CPWD Clause 14/17 terms', () {
      final case1 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 1);
      expect(case1.statutoryAct, contains('CPWD Works Manual'));
      expect(case1.category, CivicMachineryCategory.roadsAndInfra);
      final petition = case1.petitionGenerator();
      expect(petition, contains('Defect Liability Period'));
      expect(petition, contains('Executive Engineer'));
    });

    test('Case 2: Drinking Water Audit references BIS 10500:2012', () {
      final case2 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 2);
      expect(case2.statutoryAct, contains('BIS 10500'));
      expect(case2.category, CivicMachineryCategory.waterAndHealth);
      final petition = case2.petitionGenerator();
      expect(petition, contains('BIS 10500:2012'));
      expect(petition, contains('clean municipal drinking water tankers'));
    });

    test('Case 3: DISCOM Outage references SERC and Electricity Act 2003', () {
      final case3 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 3);
      expect(case3.statutoryAct, contains('Electricity Act 2003'));
      expect(case3.category, CivicMachineryCategory.powerAndUtilities);
      final petition = case3.petitionGenerator();
      expect(petition, contains('Electricity Regulatory Commission'));
      expect(petition, contains('Standards of Performance'));
    });

    test('Case 4: Solid Waste & Burning references SWM Rules 2016 and NGT', () {
      final case4 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 4);
      expect(case4.statutoryAct, contains('Solid Waste Management Rules 2016'));
      expect(case4.category, CivicMachineryCategory.environmentAndAir);
      final petition = case4.petitionGenerator();
      expect(petition, contains('National Green Tribunal'));
      expect(petition, contains('Statutory Spot Environmental Compensation'));
    });

    test('Case 5: Open Manhole Hazard references Section 133 CrPC / 152 BNSS', () {
      final case5 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 5);
      expect(case5.statutoryAct, contains('Section 133 CrPC'));
      expect(case5.category, CivicMachineryCategory.roadsAndInfra);
      final petition = case5.petitionGenerator();
      expect(petition, contains('Sub-Divisional Magistrate'));
      expect(petition, contains('Ratlam'));
    });

    test('Case 6: Animal Birth Control references ABC Rules 2023', () {
      final case6 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 6);
      expect(case6.statutoryAct, contains('Animal Birth Control'));
      expect(case6.category, CivicMachineryCategory.socialWelfareAndSafety);
      final petition = case6.petitionGenerator();
      expect(petition, contains('Animal Birth Control'));
      expect(petition, contains('2023'));
    });

    test('Case 7: Property Tax Appeal references Section 138 Municipal Act', () {
      final case7 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 7);
      expect(case7.statutoryAct, contains('Section 138'));
      expect(case7.category, CivicMachineryCategory.revenueAndTransparency);
      final petition = case7.petitionGenerator();
      expect(petition, contains('Assessor & Collector'));
    });

    test('Case 8: Street Vendors Act references 2014 Act and TVC', () {
      final case8 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 8);
      expect(case8.statutoryAct, contains('Street Vendors'));
      expect(case8.category, CivicMachineryCategory.revenueAndTransparency);
      final petition = case8.petitionGenerator();
      expect(petition, contains('Town Vending Committee'));
    });

    test('Case 9: Noise Pollution references Noise Rules 2000 Rule 8', () {
      final case9 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 9);
      expect(case9.statutoryAct, contains('Noise Pollution'));
      expect(case9.category, CivicMachineryCategory.environmentAndAir);
      final petition = case9.petitionGenerator();
      expect(petition, contains('Station House Officer'));
    });

    test('Case 10: Safe City Lighting references Safe City SLA', () {
      final case10 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 10);
      expect(case10.statutoryAct, contains('Safe City'));
      expect(case10.category, CivicMachineryCategory.socialWelfareAndSafety);
      final petition = case10.petitionGenerator();
      expect(petition, contains('HIGH-RISK WOMEN COMMUTE ROUTE'));
      expect(petition, contains('LED luminaire'));
    });

    test('Case 11: Tree Preservation Act references Section 8/24 stop-work', () {
      final case11 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 11);
      expect(case11.statutoryAct, contains('Preservation of Trees'));
      expect(case11.category, CivicMachineryCategory.environmentAndAir);
      final petition = case11.petitionGenerator();
      expect(petition, contains('Tree Officer'));
    });

    test('Case 12: NFSA PDS Foodgrains references Section 15 DGRO', () {
      final case12 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 12);
      expect(case12.statutoryAct, contains('National Food Security Act 2013'));
      expect(case12.category, CivicMachineryCategory.socialWelfareAndSafety);
      final petition = case12.petitionGenerator();
      expect(petition, contains('District Grievance Redressal Officer'));
    });

    test('Case 13: NHM Essential Medicines references IPHS standards', () {
      final case13 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 13);
      expect(case13.statutoryAct, contains('Indian Public Health Standards'));
      expect(case13.category, CivicMachineryCategory.socialWelfareAndSafety);
      final petition = case13.petitionGenerator();
      expect(petition, contains('Chief Medical Officer'));
    });

    test('Case 14: RTPS & Vigilance references RTPS Act and ACB 1064', () {
      final case14 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 14);
      expect(case14.statutoryAct, contains('Public Services Act'));
      expect(case14.category, CivicMachineryCategory.revenueAndTransparency);
      final petition = case14.petitionGenerator();
      expect(petition, contains('STATUTORY BREACH UNDER RIGHT TO GUARANTEED DELIVERY OF SERVICES'));
      expect(petition, contains('Statutory Compensation Due to Citizen'));
    });

    test('Case 15: Vector Borne Control references Section 214 Municipal Act', () {
      final case15 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 15);
      expect(case15.statutoryAct, contains('Section 214'));
      expect(case15.category, CivicMachineryCategory.waterAndHealth);
      final petition = case15.petitionGenerator();
      expect(petition, contains('District Malaria Officer'));
    });

    test('Case 16: CAQM & GRAP Dust references CAQM Act 2021', () {
      final case16 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 16);
      expect(case16.statutoryAct, contains('CAQM'));
      expect(case16.category, CivicMachineryCategory.environmentAndAir);
      final petition = case16.petitionGenerator();
      expect(petition, contains('Member Secretary'));
    });

    test('Case 17: Municipal Parks references Child Safety Standards', () {
      final case17 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 17);
      expect(case17.statutoryAct, contains('Horticulture'));
      expect(case17.category, CivicMachineryCategory.roadsAndInfra);
      final petition = case17.petitionGenerator();
      expect(petition, contains('PUBLIC PARK REJUVENATION & SAFETY REQUISITION'));
      expect(petition, contains('Horticulture'));
    });

    test('Case 18: Water-Sewer Cross Contamination references Bio-Hazard SLA', () {
      final case18 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 18);
      expect(case18.statutoryAct, contains('Disaster Management Act 2005'));
      expect(case18.category, CivicMachineryCategory.waterAndHealth);
      final petition = case18.petitionGenerator();
      expect(petition, contains('CRITICAL BIO-HAZARD ALERT'));
      expect(petition, contains('IMMEDIATE VALVE SHUTOFF'));
    });

    test('Case 19: UBBL Unauthorized Construction references Sec 343/344', () {
      final case19 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 19);
      expect(case19.statutoryAct, contains('Section 343 & 344'));
      expect(case19.category, CivicMachineryCategory.revenueAndTransparency);
      final petition = case19.petitionGenerator();
      expect(petition, contains('STATUTORY REPORT UNDER SECTION 343 & 344'));
      expect(petition, contains('Stop-Work Order'));
    });

    test('Case 20: RTI First Appeal & Lokayukta references Section 19(1)', () {
      final case20 = GovtMachineryRegistry.getAllCases().firstWhere((c) => c.caseNumber == 20);
      expect(case20.statutoryAct, contains('Section 19(1) of Right to Information Act 2005'));
      expect(case20.category, CivicMachineryCategory.revenueAndTransparency);
      final petition = case20.petitionGenerator();
      expect(petition, contains('First Appellate Authority'));
      expect(petition, contains('Section 7(6)'));
    });
  });

  group('GovtMachineryHubScreen AQIL Multi-Viewport Responsive Tests', () {
    final viewports = [
      {'name': 'Compact Mobile (320x640)', 'size': const Size(320, 640)},
      {'name': 'Standard Mobile (393x851)', 'size': const Size(393, 851)},
      {'name': 'Large Mobile (412x915)', 'size': const Size(412, 915)},
      {'name': 'Tablet Portrait (800x1280)', 'size': const Size(800, 1280)},
      {'name': 'Tablet/Desktop Landscape (1280x800)', 'size': const Size(1280, 800)},
    ];

    for (final vp in viewports) {
      testWidgets('Renders zero overflow on ${vp['name']}', (tester) async {
        final size = vp['size'] as Size;
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          const MaterialApp(
            home: GovtMachineryHubScreen(isHindi: false),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GovtMachineryHubScreen), findsOneWidget);
        expect(find.textContaining('Civic Machinery Hub'), findsOneWidget);
        expect(find.byType(Card), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('Renders without overflow with dynamic accessibility font scale 1.5x', (tester) async {
      tester.view.physicalSize = const Size(393, 851);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: GovtMachineryHubScreen(isHindi: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GovtMachineryHubScreen), findsOneWidget);
      expect(find.textContaining('सरकारी मशीनरी'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Category filtering displays relevant cases', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GovtMachineryHubScreen(isHindi: false),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Roads & Infrastructure chip
      final roadsChip = find.widgetWithText(ChoiceChip, 'Roads & Infrastructure');
      expect(roadsChip, findsOneWidget);
      await tester.tap(roadsChip);
      await tester.pumpAndSettle();

      // Roads & Infra category should have Cases #1, #17
      expect(find.text('CASE #01'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Search query filters cases dynamically', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GovtMachineryHubScreen(isHindi: false),
        ),
      );
      await tester.pumpAndSettle();

      // Enter search query "Lokayukta"
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Lokayukta');
      await tester.pumpAndSettle();

      expect(find.text('CASE #20'), findsOneWidget);
      expect(find.text('CASE #01'), findsNothing);
    });

    testWidgets('Tapping petition button opens modal bottom sheet with action controls', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GovtMachineryHubScreen(isHindi: false),
        ),
      );
      await tester.pumpAndSettle();

      final petitionButtons = find.widgetWithText(ElevatedButton, 'Generate Legal Petition & Dossier');
      expect(petitionButtons, findsWidgets);

      await tester.tap(petitionButtons.first);
      await tester.pumpAndSettle();

      // Verify modal sheet is displayed
      expect(find.text('Copy Dossier'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Email Notice'), findsOneWidget);

      // Tap Copy Dossier
      await tester.tap(find.text('Copy Dossier'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
