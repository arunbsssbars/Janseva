import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/models/offline_sync_action.dart';
import 'package:janseva_mobile/core/services/offline_sync_service.dart';

void main() {
  group('OfflineSyncService & Queue Tests', () {
    late OfflineSyncService syncService;

    setUp(() {
      syncService = OfflineSyncService();
    });

    test('enqueues actions and tracks pending count', () {
      final action1 = OfflineSyncAction(
        id: 'ACT-1',
        type: SyncActionType.createGrievance,
        payload: {'title': 'Pothole on Main St', 'wardId': 'ward_1'},
        createdAt: DateTime.now(),
      );

      final action2 = OfflineSyncAction(
        id: 'ACT-2',
        type: SyncActionType.upvoteGrievance,
        payload: {'grievanceId': 'G-101'},
        createdAt: DateTime.now(),
      );

      syncService.enqueue(action1);
      syncService.enqueue(action2);

      expect(syncService.pendingCount, equals(2));
      expect(syncService.queue.length, equals(2));
    });

    test('marks actions failed when network is unavailable and tracks retry count', () async {
      final action = OfflineSyncAction(
        id: 'ACT-3',
        type: SyncActionType.submitCsat,
        payload: {'rating': 5},
        createdAt: DateTime.now(),
      );
      syncService.enqueue(action);

      final result = await syncService.processQueue(isNetworkAvailable: false);

      expect(result.failedCount, equals(1));
      expect(result.successCount, equals(0));
      expect(syncService.failedCount, equals(1));
      expect(syncService.queue.first.retryCount, equals(1));
      expect(syncService.queue.first.status, equals(SyncStatus.failed));
    });

    test('successfully reconciles actions when online and resolves conflicts', () async {
      final oldClientTime = DateTime(2026, 1, 1, 10, 0);
      final newerServerTime = DateTime(2026, 1, 1, 11, 0);

      // Action with conflicting older client modification
      final conflictingAction = OfflineSyncAction(
        id: 'ACT-4',
        type: SyncActionType.verifyResolution,
        payload: {'targetId': 'G-200', 'status': 'closed'},
        createdAt: oldClientTime,
      );

      // Normal non-conflicting action
      final normalAction = OfflineSyncAction(
        id: 'ACT-5',
        type: SyncActionType.createForumPost,
        payload: {'title': 'New Park Proposal'},
        createdAt: DateTime.now(),
      );

      syncService.enqueue(conflictingAction);
      syncService.enqueue(normalAction);

      final result = await syncService.processQueue(
        isNetworkAvailable: true,
        serverEntityTimestamps: {'G-200': newerServerTime},
      );

      expect(result.conflictsResolved, equals(1));
      expect(result.successCount, equals(1));
      expect(result.failedCount, equals(0));

      final firstAction = syncService.queue.firstWhere((a) => a.id == 'ACT-4');
      expect(firstAction.status, equals(SyncStatus.conflictResolved));
      expect(firstAction.lastError, contains('Server record modified more recently'));

      final secondAction = syncService.queue.firstWhere((a) => a.id == 'ACT-5');
      expect(secondAction.status, equals(SyncStatus.synced));

      // Clean up completed actions
      syncService.clearCompleted();
      expect(syncService.queue.isEmpty, isTrue);
    });
  });
}
