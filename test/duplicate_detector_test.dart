import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/services/duplicate_detector.dart';

void main() {
  group('DuplicateGrievanceDetector Test Suite', () {
    final now = DateTime.now();
    final sampleGrievances = [
      Grievance(
        id: 'GRV-DUP-1',
        title: 'Deep crater pothole near metro pillar 42',
        description: 'Dangerous road hole',
        category: GrievanceCategory.roadsAndPotholes,
        status: GrievanceStatus.inProgress,
        priority: GrievancePriority.high,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'MG Road',
        landmark: 'Near Metro',
        citizenId: 'USR-01',
        citizenName: 'Citizen',
        citizenPhone: '123',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(hours: 24)),
      ),
      Grievance(
        id: 'GRV-DUP-2',
        title: 'Garbage dump overflowing',
        description: 'Bin full of trash',
        category: GrievanceCategory.sanitationAndGarbage,
        status: GrievanceStatus.submitted,
        priority: GrievancePriority.medium,
        wardId: 'W-02',
        wardName: 'Gandhi Nagar',
        latitude: 28.65,
        longitude: 77.26,
        address: 'Sector 5',
        landmark: 'Market',
        citizenId: 'USR-02',
        citizenName: 'Citizen 2',
        citizenPhone: '456',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(hours: 24)),
      ),
    ];

    test('Detects duplicate with same ward, same category and shared keywords', () {
      final duplicates = DuplicateGrievanceDetector.findPotentialDuplicates(
        activeGrievances: sampleGrievances,
        newTitle: 'Huge dangerous pothole near pillar 42',
        newDescription: 'Vehicles might fall',
        newCategory: GrievanceCategory.roadsAndPotholes,
        newWardId: 'W-01',
      );

      expect(duplicates.isNotEmpty, isTrue);
      expect(duplicates.first.existingGrievance.id, equals('GRV-DUP-1'));
      expect(duplicates.first.similarityScore, greaterThanOrEqualTo(0.6));
    });

    test('Returns empty when category and ward differ completely', () {
      final duplicates = DuplicateGrievanceDetector.findPotentialDuplicates(
        activeGrievances: sampleGrievances,
        newTitle: 'Dark streetlights at night',
        newDescription: 'Lights broken',
        newCategory: GrievanceCategory.electricityAndStreetlights,
        newWardId: 'W-03',
      );

      expect(duplicates.isEmpty, isTrue);
    });
  });
}
