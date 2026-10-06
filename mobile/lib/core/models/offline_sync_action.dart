enum SyncActionType {
  createGrievance,
  verifyResolution,
  upvoteGrievance,
  createForumPost,
  submitCsat,
  inspectionAudit;

  String get labelEn {
    switch (this) {
      case SyncActionType.createGrievance:
        return 'Report Grievance';
      case SyncActionType.verifyResolution:
        return 'Verify Resolution';
      case SyncActionType.upvoteGrievance:
        return 'Upvote Issue';
      case SyncActionType.createForumPost:
        return 'Post Ward Proposal';
      case SyncActionType.submitCsat:
        return 'Submit CSAT Survey';
      case SyncActionType.inspectionAudit:
        return 'Field Inspection Record';
    }
  }
}

enum SyncStatus {
  pending,
  syncing,
  synced,
  failed,
  conflictResolved;
}

class OfflineSyncAction {
  final String id;
  final SyncActionType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final int maxRetries;
  final String? lastError;
  final SyncStatus status;

  const OfflineSyncAction({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.maxRetries = 3,
    this.lastError,
    this.status = SyncStatus.pending,
  });

  bool get canRetry => retryCount < maxRetries && status == SyncStatus.failed;

  OfflineSyncAction copyWith({
    String? id,
    SyncActionType? type,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    int? maxRetries,
    String? lastError,
    SyncStatus? status,
  }) {
    return OfflineSyncAction(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      lastError: lastError ?? this.lastError,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
        'maxRetries': maxRetries,
        'lastError': lastError,
        'status': status.name,
      };

  factory OfflineSyncAction.fromJson(Map<String, dynamic> json) {
    return OfflineSyncAction(
      id: json['id'] as String,
      type: SyncActionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => SyncActionType.createGrievance,
      ),
      payload: Map<String, dynamic>.from(json['payload'] as Map? ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      retryCount: json['retryCount'] as int? ?? 0,
      maxRetries: json['maxRetries'] as int? ?? 3,
      lastError: json['lastError'] as String?,
      status: SyncStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => SyncStatus.pending,
      ),
    );
  }
}
