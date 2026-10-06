class ParticipatoryBudgetItem {
  final String id;
  final String title;
  final String description;
  final String ward;
  final double estimatedCostLakhs;
  final int totalVotes;
  final bool hasVoted;

  const ParticipatoryBudgetItem({
    required this.id,
    required this.title,
    required this.description,
    required this.ward,
    required this.estimatedCostLakhs,
    required this.totalVotes,
    this.hasVoted = false,
  });

  ParticipatoryBudgetItem copyWith({
    String? id,
    String? title,
    String? description,
    String? ward,
    double? estimatedCostLakhs,
    int? totalVotes,
    bool? hasVoted,
  }) {
    return ParticipatoryBudgetItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ward: ward ?? this.ward,
      estimatedCostLakhs: estimatedCostLakhs ?? this.estimatedCostLakhs,
      totalVotes: totalVotes ?? this.totalVotes,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}
