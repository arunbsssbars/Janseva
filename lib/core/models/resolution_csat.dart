class ResolutionCsat {
  final String grievanceId;
  final int overallRating; // 1 to 5
  final int speedRating; // 1 to 5
  final int qualityRating; // 1 to 5
  final int officerBehaviorRating; // 1 to 5
  final bool wouldRecommend;
  final String comments;
  final DateTime submittedAt;

  const ResolutionCsat({
    required this.grievanceId,
    required this.overallRating,
    required this.speedRating,
    required this.qualityRating,
    required this.officerBehaviorRating,
    required this.wouldRecommend,
    required this.comments,
    required this.submittedAt,
  });

  double get averageScore =>
      (overallRating + speedRating + qualityRating + officerBehaviorRating) / 4.0;

  Map<String, dynamic> toJson() => {
        'grievanceId': grievanceId,
        'overallRating': overallRating,
        'speedRating': speedRating,
        'qualityRating': qualityRating,
        'officerBehaviorRating': officerBehaviorRating,
        'wouldRecommend': wouldRecommend,
        'comments': comments,
        'submittedAt': submittedAt.toIso8601String(),
        'averageScore': averageScore,
      };

  factory ResolutionCsat.fromJson(Map<String, dynamic> json) {
    return ResolutionCsat(
      grievanceId: json['grievanceId'] as String? ?? '',
      overallRating: json['overallRating'] as int? ?? 5,
      speedRating: json['speedRating'] as int? ?? 5,
      qualityRating: json['qualityRating'] as int? ?? 5,
      officerBehaviorRating: json['officerBehaviorRating'] as int? ?? 5,
      wouldRecommend: json['wouldRecommend'] as bool? ?? true,
      comments: json['comments'] as String? ?? '',
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
