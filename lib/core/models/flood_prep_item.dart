class FloodPrepCheckItem {
  final String id;
  final String category; // 'Drainage', 'Emergency Kit', 'Electrical Safety', 'Evacuation'
  final String title;
  final String description;
  final bool isCompleted;

  const FloodPrepCheckItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  FloodPrepCheckItem copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return FloodPrepCheckItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
