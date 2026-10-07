import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/models/ward.dart';
import 'package:janseva_mobile/core/services/analytics_engine.dart';

void main() {
  group('CivicAnalyticsEngine Unit Tests', () {
    test('Calculates metrics with resolved and active grievances correctly', () {
      final now = DateTime.now();
      final wards = Ward.defaultWards();
      final grievances = [
        Grievance(
          id: 'GRV-A1',
          title: 'Resolved Pothole',
          description: '',
          category: GrievanceCategory.roadsAndPotholes,
          status: GrievanceStatus.resolved,
          priority: GrievancePriority.medium,
          wardId: 'W-01',
          wardName: 'Civil Lines',
          latitude: 0,
          longitude: 0,
          address: '',
          landmark: '',
          citizenId: '',
          citizenName: '',
          citizenPhone: '',
          createdAt: now.subtract(const Duration(hours: 12)),
          updatedAt: now,
          slaDeadline: now.add(const Duration(hours: 24)),
          resolvedAt: now.subtract(const Duration(hours: 2)),
        ),
        Grievance(
          id: 'GRV-A2',
          title: 'Active Garbage',
          description: '',
          category: GrievanceCategory.sanitationAndGarbage,
          status: GrievanceStatus.inProgress,
          priority: GrievancePriority.high,
          wardId: 'W-02',
          wardName: 'Gandhi Nagar',
          latitude: 0,
          longitude: 0,
          address: '',
          landmark: '',
          citizenId: '',
          citizenName: '',
          citizenPhone: '',
          createdAt: now.subtract(const Duration(hours: 30)),
          updatedAt: now,
          slaDeadline: now.subtract(const Duration(hours: 6)), // Breached
        ),
      ];

      final data = CivicAnalyticsEngine.computeAnalytics(
        grievances: grievances,
        wards: wards,
      );

      expect(data.totalGrievances, equals(2));
      expect(data.resolvedGrievances, equals(1));
      expect(data.breachedGrievances, equals(1));
      expect(data.slaComplianceRate, equals(50.0));
      expect(data.wardRankings.isNotEmpty, isTrue);
    });
  });
}
