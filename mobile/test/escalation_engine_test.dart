import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/services/escalation_engine.dart';

void main() {
  group('CivicEscalationEngine Unit Tests', () {
    final baseTime = DateTime(2026, 10, 1, 10, 0); // Oct 1, 10:00
    final deadline = DateTime(2026, 10, 3, 10, 0); // 48 hours SLA (Oct 3, 10:00)

    Grievance createTestGrievance({GrievanceStatus status = GrievanceStatus.inProgress}) {
      return Grievance(
        id: 'test-g-1',
        title: 'Open sewer line leak',
        description: 'Sewage overflowing onto pedestrian lane',
        category: GrievanceCategory.sewageAndDrainage,
        priority: GrievancePriority.high,
        status: status,
        wardId: 'w-03',
        wardName: 'Civil Lines',
        citizenId: 'c-1',
        citizenName: 'Dev Citizen',
        citizenPhone: '9876543210',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'Lane 4, Sector B',
        landmark: 'Near Water Tank',
        createdAt: baseTime,
        updatedAt: baseTime,
        slaDeadline: deadline,
      );
    }

    test('Returns normal tier when SLA is below 75%', () {
      // 24 hours into a 48 hour SLA = 50%
      final evalTime = baseTime.add(const Duration(hours: 24));
      final g = createTestGrievance();

      final eval = CivicEscalationEngine.evaluate(g, currentTime: evalTime);
      expect(eval.tier, EscalationTier.normal);
      expect(eval.elapsedPercentage, closeTo(50.0, 0.1));
    });

    test('Returns warning tier when SLA is between 75% and 100%', () {
      // 40 hours into a 48 hour SLA = 83.3%
      final evalTime = baseTime.add(const Duration(hours: 40));
      final g = createTestGrievance();

      final eval = CivicEscalationEngine.evaluate(g, currentTime: evalTime);
      expect(eval.tier, EscalationTier.warning);
      expect(eval.authority, 'Ward Field Officer');
    });

    test('Returns tier1Breach when SLA is between 100% and 150%', () {
      // 54 hours into a 48 hour SLA = 112.5%
      final evalTime = baseTime.add(const Duration(hours: 54));
      final g = createTestGrievance();

      final eval = CivicEscalationEngine.evaluate(g, currentTime: evalTime);
      expect(eval.tier, EscalationTier.tier1Breach);
      expect(eval.authority, 'Zonal Executive Engineer');
      expect(eval.overdueDuration.inHours, 6);
    });

    test('Returns criticalBreach when SLA exceeds 150%', () {
      // 80 hours into a 48 hour SLA = 166.7%
      final evalTime = baseTime.add(const Duration(hours: 80));
      final g = createTestGrievance();

      final eval = CivicEscalationEngine.evaluate(g, currentTime: evalTime);
      expect(eval.tier, EscalationTier.criticalBreach);
      expect(eval.authority, 'Municipal Commissioner Cell');
      expect(eval.overdueDuration.inHours, 32);
    });

    test('Terminal grievances (resolved/verifiedClosed) remain normal tier', () {
      final evalTime = baseTime.add(const Duration(hours: 100));
      final g = createTestGrievance(status: GrievanceStatus.resolved);

      final eval = CivicEscalationEngine.evaluate(g, currentTime: evalTime);
      expect(eval.tier, EscalationTier.normal);
    });
  });
}
