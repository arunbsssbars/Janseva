import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/govt_channel.dart';
import 'package:janseva_mobile/core/services/govt_grievance_dispatcher.dart';

void main() {
  group('GovtGrievanceDispatcher Unit Tests', () {
    test('routes roads and potholes to Municipal ULB 311 with 48h SLA', () {
      final routing = GovtGrievanceDispatcher.resolveRouting(GrievanceCategory.roadsAndPotholes);
      expect(routing.targetPortal, equals(GovtPortalType.municipal311));
      expect(routing.statutorySlaHours, equals(48));
      expect(routing.departmentNameEn.contains('Public Works'), isTrue);
    });

    test('routes water supply to Jal Board with 24h SLA and 1916 helpline', () {
      final routing = GovtGrievanceDispatcher.resolveRouting(GrievanceCategory.waterSupply);
      expect(routing.targetPortal, equals(GovtPortalType.jalBoard));
      expect(routing.statutorySlaHours, equals(24));
      expect(routing.helplineNumber, equals('1916'));
    });

    test('routes sanitation to Swachhata portal with 24h SLA', () {
      final routing = GovtGrievanceDispatcher.resolveRouting(GrievanceCategory.sanitationAndGarbage);
      expect(routing.targetPortal, equals(GovtPortalType.swachhata));
      expect(routing.statutorySlaHours, equals(24));
    });

    test('generates valid official docket number and acknowledgment receipt', () {
      final receipt = GovtGrievanceDispatcher.dispatchToGovtPortal(
        grievanceId: 'GRV-2026-999',
        category: GrievanceCategory.electricityAndStreetlights,
        citizenPhone: '+91 98100 11223',
        wardName: 'Ward 1 - Civil Lines',
      );

      expect(receipt.docketNumber.startsWith('JS-PWR-'), isTrue);
      expect(receipt.portal, equals(GovtPortalType.discomPower));
      expect(receipt.slaHours, equals(36));
      expect(receipt.acknowledgmentSmsText.contains('Docket'), isTrue);
    });
  });
}
