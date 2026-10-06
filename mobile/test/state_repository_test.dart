import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/repository/civic_repository.dart';
import 'package:janseva_mobile/core/state/janseva_state.dart';

void main() {
  group('JanSeva State and Repository Tests', () {
    late InMemoryCivicRepository repository;
    late JanSevaState state;

    setUp(() {
      repository = InMemoryCivicRepository();
      state = JanSevaState(repository: repository);
    });

    test('Initial state loads seed grievances and wards', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      expect(state.grievances.length, greaterThanOrEqualTo(4));
      expect(state.wards.length, equals(5));
      expect(state.currentUser.role, equals(UserRole.citizen));
    });

    test('Filter by status updates list correctly', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      state.setFilterStatus(GrievanceStatus.resolved);
      await Future.delayed(const Duration(milliseconds: 50));
      for (final g in state.grievances) {
        expect(g.status, equals(GrievanceStatus.resolved));
      }
    });

    test('Upvoting toggles citizen upvote', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      final initial = state.grievances.first;
      final initialCount = initial.upvoteCount;

      await state.upvote(initial.id);
      final updated = state.grievances.firstWhere((g) => g.id == initial.id);
      expect(updated.upvoteCount, anyOf(equals(initialCount + 1), equals(initialCount - 1)));
    });

    test('Create new grievance in offline mode marks it as pending sync', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      state.toggleOnlineStatus();
      expect(state.isOnline, isFalse);

      final created = await state.createGrievance(
        title: 'Broken streetlight outside house',
        description: 'Dark corner at night',
        category: GrievanceCategory.electricityAndStreetlights,
        priority: GrievancePriority.medium,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        address: 'House 42, Civil Lines',
        landmark: 'Near Temple',
        latitude: 28.6139,
        longitude: 77.2090,
      );

      expect(created.isOfflineSyncPending, isTrue);
      expect(state.offlinePendingCount, greaterThan(0));

      final syncedCount = await state.syncOfflineReports();
      expect(syncedCount, greaterThan(0));
    });

    test('Switch role switches user profile and permissions', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      expect(state.currentUser.isOfficer, isFalse);

      await state.switchRole(UserRole.wardOfficer);
      expect(state.currentUser.isOfficer, isTrue);
      expect(state.currentUser.role, equals(UserRole.wardOfficer));
    });
  });
}
