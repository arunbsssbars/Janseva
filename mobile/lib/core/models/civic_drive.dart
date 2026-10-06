class CivicDrive {
  final String id;
  final String title;
  final String description;
  final String ward;
  final String organizer;
  final DateTime scheduledDate;
  final int targetVolunteers;
  final int registeredVolunteers;
  final String driveType; // 'tree_plantation', 'cleanliness_swachhata', 'pothole_fix'
  final bool isUserRegistered;

  const CivicDrive({
    required this.id,
    required this.title,
    required this.description,
    required this.ward,
    required this.organizer,
    required this.scheduledDate,
    required this.targetVolunteers,
    required this.registeredVolunteers,
    required this.driveType,
    this.isUserRegistered = false,
  });

  CivicDrive copyWith({
    String? id,
    String? title,
    String? description,
    String? ward,
    String? organizer,
    DateTime? scheduledDate,
    int? targetVolunteers,
    int? registeredVolunteers,
    String? driveType,
    bool? isUserRegistered,
  }) {
    return CivicDrive(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ward: ward ?? this.ward,
      organizer: organizer ?? this.organizer,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      targetVolunteers: targetVolunteers ?? this.targetVolunteers,
      registeredVolunteers: registeredVolunteers ?? this.registeredVolunteers,
      driveType: driveType ?? this.driveType,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
    );
  }

  double get participationProgress =>
      targetVolunteers > 0 ? (registeredVolunteers / targetVolunteers).clamp(0.0, 1.0) : 0.0;
}
