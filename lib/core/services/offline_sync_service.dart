import 'dart:async';
import '../models/offline_sync_action.dart';

class SyncProcessResult {
  final int totalProcessed;
  final int successCount;
  final int failedCount;
  final int conflictsResolved;
  final List<String> errorMessages;

  const SyncProcessResult({
    required this.totalProcessed,
    required this.successCount,
    required this.failedCount,
    required this.conflictsResolved,
    this.errorMessages = const [],
  });
}

class OfflineSyncService {
  final List<OfflineSyncAction> _queue = [];
  bool _isProcessing = false;

  List<OfflineSyncAction> get queue => List.unmodifiable(_queue);
  bool get isProcessing => _isProcessing;
  int get pendingCount => _queue.where((a) => a.status == SyncStatus.pending).length;
  int get failedCount => _queue.where((a) => a.status == SyncStatus.failed).length;

  void enqueue(OfflineSyncAction action) {
    _queue.add(action);
  }

  void removeAction(String actionId) {
    _queue.removeWhere((a) => a.id == actionId);
  }

  void clearCompleted() {
    _queue.removeWhere(
      (a) => a.status == SyncStatus.synced || a.status == SyncStatus.conflictResolved,
    );
  }

  /// Processes all pending or retryable actions in FIFO order
  Future<SyncProcessResult> processQueue({
    bool isNetworkAvailable = true,
    Map<String, DateTime>? serverEntityTimestamps,
  }) async {
    if (_isProcessing) {
      return const SyncProcessResult(
        totalProcessed: 0,
        successCount: 0,
        failedCount: 0,
        conflictsResolved: 0,
      );
    }

    _isProcessing = true;
    int success = 0;
    int failed = 0;
    int conflicts = 0;
    final List<String> errors = [];

    try {
      for (int i = 0; i < _queue.length; i++) {
        final action = _queue[i];

        // Process only pending or retryable failed actions
        if (action.status != SyncStatus.pending && !action.canRetry) {
          continue;
        }

        if (!isNetworkAvailable) {
          _queue[i] = action.copyWith(
            status: SyncStatus.failed,
            lastError: 'Network gateway unavailable. Queued for background sync.',
            retryCount: action.retryCount + 1,
          );
          failed++;
          continue;
        }

        // Conflict check: if server has a newer modification timestamp
        final targetId = action.payload['targetId'] as String?;
        if (targetId != null && serverEntityTimestamps != null && serverEntityTimestamps.containsKey(targetId)) {
          final serverTime = serverEntityTimestamps[targetId]!;
          if (serverTime.isAfter(action.createdAt)) {
            // Conflict: server state takes precedence or is merged
            _queue[i] = action.copyWith(
              status: SyncStatus.conflictResolved,
              lastError: 'Server record modified more recently ($serverTime); reconciled.',
            );
            conflicts++;
            continue;
          }
        }

        // Simulate successful processing
        _queue[i] = action.copyWith(
          status: SyncStatus.synced,
          lastError: null,
        );
        success++;
      }
    } catch (e) {
      errors.add(e.toString());
    } finally {
      _isProcessing = false;
    }

    return SyncProcessResult(
      totalProcessed: success + failed + conflicts,
      successCount: success,
      failedCount: failed,
      conflictsResolved: conflicts,
      errorMessages: errors,
    );
  }
}
