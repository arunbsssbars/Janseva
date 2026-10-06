import '../enums/civic_enums.dart';
import 'grievance_timeline.dart';

class Grievance {
  final String id;
  final String title;
  final String description;
  final GrievanceCategory category;
  final GrievanceStatus status;
  final GrievancePriority priority;
  final String wardId;
  final String wardName;
  final double latitude;
  final double longitude;
  final String address;
  final String landmark;
  final String citizenId;
  final String citizenName;
  final String citizenPhone;
  final List<String> photoUrls;
  final int upvoteCount;
  final List<String> upvotedUserIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime slaDeadline;
  final DateTime? resolvedAt;
  final String? assignedOfficerName;
  final String? resolutionNotes;
  final List<String> resolutionPhotoUrls;
  final int? citizenRating;
  final String? citizenFeedback;
  final bool isOfflineSyncPending;
  final List<GrievanceTimelineEvent> timeline;

  const Grievance({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.wardId,
    required this.wardName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.landmark,
    required this.citizenId,
    required this.citizenName,
    required this.citizenPhone,
    this.photoUrls = const [],
    this.upvoteCount = 0,
    this.upvotedUserIds = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.slaDeadline,
    this.resolvedAt,
    this.assignedOfficerName,
    this.resolutionNotes,
    this.resolutionPhotoUrls = const [],
    this.citizenRating,
    this.citizenFeedback,
    this.isOfflineSyncPending = false,
    this.timeline = const [],
  });

  bool get isSlaBreached {
    if (status == GrievanceStatus.resolved ||
        status == GrievanceStatus.verifiedClosed) {
      if (resolvedAt != null) {
        return resolvedAt!.isAfter(slaDeadline);
      }
      return false;
    }
    return DateTime.now().isAfter(slaDeadline);
  }

  Duration get timeRemainingUntilSla {
    final now = DateTime.now();
    if (slaDeadline.isBefore(now)) return Duration.zero;
    return slaDeadline.difference(now);
  }

  double get slaProgressFraction {
    final totalDuration = slaDeadline.difference(createdAt).inMinutes;
    if (totalDuration <= 0) return 1.0;
    final elapsed = DateTime.now().difference(createdAt).inMinutes;
    final fraction = elapsed / totalDuration;
    return fraction.clamp(0.0, 1.0);
  }

  Grievance copyWith({
    String? id,
    String? title,
    String? description,
    GrievanceCategory? category,
    GrievanceStatus? status,
    GrievancePriority? priority,
    String? wardId,
    String? wardName,
    double? latitude,
    double? longitude,
    String? address,
    String? landmark,
    String? citizenId,
    String? citizenName,
    String? citizenPhone,
    List<String>? photoUrls,
    int? upvoteCount,
    List<String>? upvotedUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? slaDeadline,
    DateTime? resolvedAt,
    String? assignedOfficerName,
    String? resolutionNotes,
    List<String>? resolutionPhotoUrls,
    int? citizenRating,
    String? citizenFeedback,
    bool? isOfflineSyncPending,
    List<GrievanceTimelineEvent>? timeline,
  }) {
    return Grievance(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      landmark: landmark ?? this.landmark,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      citizenPhone: citizenPhone ?? this.citizenPhone,
      photoUrls: photoUrls ?? this.photoUrls,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      upvotedUserIds: upvotedUserIds ?? this.upvotedUserIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slaDeadline: slaDeadline ?? this.slaDeadline,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedOfficerName: assignedOfficerName ?? this.assignedOfficerName,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      resolutionPhotoUrls: resolutionPhotoUrls ?? this.resolutionPhotoUrls,
      citizenRating: citizenRating ?? this.citizenRating,
      citizenFeedback: citizenFeedback ?? this.citizenFeedback,
      isOfflineSyncPending: isOfflineSyncPending ?? this.isOfflineSyncPending,
      timeline: timeline ?? this.timeline,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.code,
    'status': status.code,
    'priority': priority.name,
    'wardId': wardId,
    'wardName': wardName,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'landmark': landmark,
    'citizenId': citizenId,
    'citizenName': citizenName,
    'citizenPhone': citizenPhone,
    'photoUrls': photoUrls,
    'upvoteCount': upvoteCount,
    'upvotedUserIds': upvotedUserIds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'slaDeadline': slaDeadline.toIso8601String(),
    'resolvedAt': resolvedAt?.toIso8601String(),
    'assignedOfficerName': assignedOfficerName,
    'resolutionNotes': resolutionNotes,
    'resolutionPhotoUrls': resolutionPhotoUrls,
    'citizenRating': citizenRating,
    'citizenFeedback': citizenFeedback,
    'isOfflineSyncPending': isOfflineSyncPending,
    'timeline': timeline.map((e) => e.toJson()).toList(),
  };

  factory Grievance.fromJson(Map<String, dynamic> json) {
    final created = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now();
    final deadline = json['slaDeadline'] != null
        ? DateTime.tryParse(json['slaDeadline'] as String) ??
            created.add(const Duration(hours: 48))
        : created.add(const Duration(hours: 48));

    return Grievance(
      id: json['id'] as String? ?? 'GRV-000',
      title: json['title'] as String? ?? 'Untitled Grievance',
      description: json['description'] as String? ?? '',
      category: GrievanceCategory.fromCode(json['category'] as String?),
      status: GrievanceStatus.fromCode(json['status'] as String?),
      priority: GrievancePriority.fromString(json['priority'] as String?),
      wardId: json['wardId'] as String? ?? 'W-01',
      wardName: json['wardName'] as String? ?? 'Civil Lines',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      address: json['address'] as String? ?? 'Municipal Area',
      landmark: json['landmark'] as String? ?? '',
      citizenId: json['citizenId'] as String? ?? 'USR-01',
      citizenName: json['citizenName'] as String? ?? 'Citizen',
      citizenPhone: json['citizenPhone'] as String? ?? '',
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      upvoteCount: json['upvoteCount'] as int? ?? 0,
      upvotedUserIds: (json['upvotedUserIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: created,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? created
          : created,
      slaDeadline: deadline,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'] as String)
          : null,
      assignedOfficerName: json['assignedOfficerName'] as String?,
      resolutionNotes: json['resolutionNotes'] as String?,
      resolutionPhotoUrls: (json['resolutionPhotoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      citizenRating: json['citizenRating'] as int?,
      citizenFeedback: json['citizenFeedback'] as String?,
      isOfflineSyncPending: json['isOfflineSyncPending'] as bool? ?? false,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => GrievanceTimelineEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
