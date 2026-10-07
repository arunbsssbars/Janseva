enum ForumTopicCategory {
  infrastructure(
    code: 'INFRA',
    titleEn: 'Infrastructure & Roads',
    titleHi: 'बुनियादी ढांचा एवं सड़कें',
  ),
  sanitation(
    code: 'SANITATION',
    titleEn: 'Cleanliness & Waste',
    titleHi: 'स्वच्छता एवं अपशिष्ट',
  ),
  parksAndGreenery(
    code: 'GREENERY',
    titleEn: 'Parks & Greenery',
    titleHi: 'पार्क एवं हरियाली',
  ),
  publicSafety(
    code: 'SAFETY',
    titleEn: 'Public Safety & Lighting',
    titleHi: 'जन सुरक्षा एवं प्रकाश',
  ),
  community(
    code: 'COMMUNITY',
    titleEn: 'Community & Culture',
    titleHi: 'सामुदायिक एवं सांस्कृतिक',
  );

  const ForumTopicCategory({
    required this.code,
    required this.titleEn,
    required this.titleHi,
  });

  final String code;
  final String titleEn;
  final String titleHi;
}

class WardForumPost {
  final String id;
  final String wardId;
  final String wardName;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final ForumTopicCategory category;
  final DateTime createdAt;
  final List<String> upvotedUserIds;
  final int commentsCount;
  final String? officialResponse;
  final String? officialResponderTitle;

  const WardForumPost({
    required this.id,
    required this.wardId,
    required this.wardName,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.upvotedUserIds = const [],
    this.commentsCount = 0,
    this.officialResponse,
    this.officialResponderTitle,
  });

  bool get hasOfficialResponse => officialResponse != null && officialResponse!.isNotEmpty;
  int get upvotesCount => upvotedUserIds.length;

  WardForumPost copyWith({
    String? id,
    String? wardId,
    String? wardName,
    String? authorId,
    String? authorName,
    String? title,
    String? content,
    ForumTopicCategory? category,
    DateTime? createdAt,
    List<String>? upvotedUserIds,
    int? commentsCount,
    String? officialResponse,
    String? officialResponderTitle,
  }) {
    return WardForumPost(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      upvotedUserIds: upvotedUserIds ?? this.upvotedUserIds,
      commentsCount: commentsCount ?? this.commentsCount,
      officialResponse: officialResponse ?? this.officialResponse,
      officialResponderTitle: officialResponderTitle ?? this.officialResponderTitle,
    );
  }

  static List<WardForumPost> mockPosts() {
    final now = DateTime.now();
    return [
      WardForumPost(
        id: 'post-1',
        wardId: 'W-01',
        wardName: 'Civil Lines',
        authorId: 'u-1',
        authorName: 'Ramesh Gupta',
        title: 'Proposal: Install Solar Smart Lighting in Gandhi Memorial Park',
        content: 'The jogging trail in Gandhi Memorial Park becomes pitch black after 7 PM. Installing 12 solar smart lights will make evening walking safe for senior citizens and women.',
        category: ForumTopicCategory.parksAndGreenery,
        createdAt: now.subtract(const Duration(hours: 18)),
        upvotedUserIds: ['u-1', 'u-2', 'u-3', 'u-4', 'u-5', 'u-6'],
        commentsCount: 14,
        officialResponse: 'Proposal accepted by Ward 1 Beautification Committee. Survey scheduled next Monday.',
        officialResponderTitle: 'Ward Junior Engineer, Electrical Div.',
      ),
      WardForumPost(
        id: 'post-2',
        wardId: 'W-01',
        wardName: 'Civil Lines',
        authorId: 'u-3',
        authorName: 'Priya Sharma',
        title: 'Speed Breaker Required near St. Mary Public School',
        content: 'Vehicles speed unchecked on the lane leading to the school gate during morning hours (7:30 - 8:30 AM). A rubberized speed table is urgently required.',
        category: ForumTopicCategory.publicSafety,
        createdAt: now.subtract(const Duration(days: 2)),
        upvotedUserIds: ['u-1', 'u-3', 'u-7', 'u-8', 'u-9'],
        commentsCount: 8,
      ),
      WardForumPost(
        id: 'post-3',
        wardId: 'W-02',
        wardName: 'Gandhi Nagar',
        authorId: 'u-4',
        authorName: 'Mohd. Salim',
        title: 'Community Composting Pit for Vegetable Market Organic Waste',
        content: 'Over 200 kg of organic waste is generated daily at the Subzi Mandi. Setting up two mechanized compost tumblers can yield fertilizer for municipal gardens.',
        category: ForumTopicCategory.sanitation,
        createdAt: now.subtract(const Duration(days: 3)),
        upvotedUserIds: ['u-2', 'u-4', 'u-10'],
        commentsCount: 5,
        officialResponse: 'Fund allocation under Swachh Bharat Urban Mission is being reviewed.',
        officialResponderTitle: 'Sanitation Superintendent',
      ),
    ];
  }
}
