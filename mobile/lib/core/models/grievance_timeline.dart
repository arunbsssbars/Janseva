import '../enums/civic_enums.dart';

class GrievanceTimelineEvent {
  final String id;
  final String grievanceId;
  final GrievanceStatus status;
  final DateTime timestamp;
  final String actorName;
  final String actorRole;
  final String message;
  final List<String> proofUrls;

  const GrievanceTimelineEvent({
    required this.id,
    required this.grievanceId,
    required this.status,
    required this.timestamp,
    required this.actorName,
    required this.actorRole,
    required this.message,
    this.proofUrls = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'grievanceId': grievanceId,
    'status': status.code,
    'timestamp': timestamp.toIso8601String(),
    'actorName': actorName,
    'actorRole': actorRole,
    'message': message,
    'proofUrls': proofUrls,
  };

  factory GrievanceTimelineEvent.fromJson(Map<String, dynamic> json) {
    return GrievanceTimelineEvent(
      id: json['id'] as String? ?? 'EVT-01',
      grievanceId: json['grievanceId'] as String? ?? '',
      status: GrievanceStatus.fromCode(json['status'] as String?),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      actorName: json['actorName'] as String? ?? 'System',
      actorRole: json['actorRole'] as String? ?? 'Automated',
      message: json['message'] as String? ?? 'Status updated',
      proofUrls: (json['proofUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
