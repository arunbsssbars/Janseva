import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/models/ward.dart';
import 'package:janseva_mobile/core/models/user_profile.dart';

void main() {
  group('Civic Enums and Domain Models Test Suite', () {
    test('GrievanceCategory correctly matches codes and fallback', () {
      expect(GrievanceCategory.fromCode('ROADS'), equals(GrievanceCategory.roadsAndPotholes));
      expect(GrievanceCategory.fromCode('SANITATION'), equals(GrievanceCategory.sanitationAndGarbage));
      expect(GrievanceCategory.fromCode('UNKNOWN_CODE'), equals(GrievanceCategory.roadsAndPotholes));
      expect(GrievanceCategory.roadsAndPotholes.slaHours, equals(48));
    });

    test('GrievanceStatus state transitions & flags', () {
      expect(GrievanceStatus.submitted.isActive, isTrue);
      expect(GrievanceStatus.resolved.canBeRated, isTrue);
      expect(GrievanceStatus.verifiedClosed.isTerminal, isTrue);
      expect(GrievanceStatus.fromCode('INVALID'), equals(GrievanceStatus.submitted));
    });

    test('Ward serialization and default wards list', () {
      final wards = Ward.defaultWards();
      expect(wards.length, equals(5));
      final w1 = wards.first;
      final json = w1.toJson();
      final revived = Ward.fromJson(json);
      expect(revived.wardNumber, equals(1));
      expect(revived.wardName, equals('Civil Lines'));
      expect(revived.displayName, contains('Ward 1'));
    });

    test('UserProfile permissions and role identification', () {
      final citizen = UserProfile.defaultCitizen();
      expect(citizen.isOfficer, isFalse);
      expect(citizen.isAdmin, isFalse);

      final officer = UserProfile.defaultOfficer();
      expect(officer.isOfficer, isTrue);
    });

    test('Grievance SLA calculation and breached logic', () {
      final now = DateTime.now();
      final activeGrievance = Grievance(
        id: 'GRV-TEST-1',
        title: 'Deep pothole on Main Street',
        description: 'Vehicles getting damaged near roundabout',
        category: GrievanceCategory.roadsAndPotholes,
        status: GrievanceStatus.inProgress,
        priority: GrievancePriority.high,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        latitude: 28.6139,
        longitude: 77.2090,
        address: '12 Ring Road',
        landmark: 'Opposite State Bank',
        citizenId: 'USR-01',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 9876543210',
        createdAt: now.subtract(const Duration(hours: 10)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        slaDeadline: now.add(const Duration(hours: 38)),
      );

      expect(activeGrievance.isSlaBreached, isFalse);
      expect(activeGrievance.timeRemainingUntilSla.inHours, greaterThan(0));

      final overdueGrievance = activeGrievance.copyWith(
        slaDeadline: now.subtract(const Duration(hours: 5)),
      );
      expect(overdueGrievance.isSlaBreached, isTrue);
      expect(overdueGrievance.timeRemainingUntilSla, equals(Duration.zero));
    });

    test('Grievance JSON serialization round-trip', () {
      final now = DateTime.now();
      final grievance = Grievance(
        id: 'GRV-ROUNDTRIP',
        title: 'Water pipe leak',
        description: 'Major leak on pipeline',
        category: GrievanceCategory.waterSupply,
        status: GrievanceStatus.submitted,
        priority: GrievancePriority.emergency,
        wardId: 'W-02',
        wardName: 'Gandhi Nagar',
        latitude: 28.65,
        longitude: 77.25,
        address: 'Sector 4',
        landmark: 'Near Water Tank',
        citizenId: 'USR-02',
        citizenName: 'Pooja Sharma',
        citizenPhone: '+91 9876500000',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(hours: 24)),
      );

      final json = grievance.toJson();
      final parsed = Grievance.fromJson(json);

      expect(parsed.id, equals('GRV-ROUNDTRIP'));
      expect(parsed.category, equals(GrievanceCategory.waterSupply));
      expect(parsed.priority, equals(GrievancePriority.emergency));
      expect(parsed.wardId, equals('W-02'));
    });
  });
}
