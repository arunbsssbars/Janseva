import 'dart:io';
import 'package:flutter/foundation.dart';
import '../enums/civic_enums.dart';
import '../models/civic_notification.dart';
import '../models/grievance.dart';
import '../models/user_profile.dart';
import '../models/ward.dart';
import '../models/ward_forum_post.dart';
import '../repository/civic_repository.dart';
import '../repository/local_file_civic_repository.dart';

class JanSevaState extends ChangeNotifier {
  final ICivicRepository _repository;

  JanSevaState({ICivicRepository? repository})
      : _repository = repository ??
            (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')
                ? InMemoryCivicRepository()
                : LocalFileCivicRepository()) {
    _initialize();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isHindi = false;
  bool get isHindi => _isHindi;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  List<Grievance> _grievances = [];
  List<Grievance> get grievances => _grievances;

  List<Ward> _wards = [];
  List<Ward> get wards => _wards;

  final List<WardForumPost> _forumPosts = WardForumPost.mockPosts();
  List<WardForumPost> get forumPosts => _forumPosts;

  final List<CivicNotification> _notifications = CivicNotification.mockNotifications();
  List<CivicNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  UserProfile _currentUser = UserProfile.defaultCitizen();
  UserProfile get currentUser => _currentUser;

  String? _selectedWardId;
  String? get selectedWardId => _selectedWardId;

  GrievanceCategory? _selectedCategory;
  GrievanceCategory? get selectedCategory => _selectedCategory;

  GrievanceStatus? _selectedStatus;
  GrievanceStatus? get selectedStatus => _selectedStatus;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _offlinePendingCount = 0;
  int get offlinePendingCount => _offlinePendingCount;

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    _wards = await _repository.getWards();
    _currentUser = await _repository.getCurrentUser();
    await refreshGrievances();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshGrievances() async {
    _grievances = await _repository.getGrievances(
      wardId: _selectedWardId,
      category: _selectedCategory,
      status: _selectedStatus,
      searchQuery: _searchQuery,
    );
    _offlinePendingCount = _grievances.where((g) => g.isOfflineSyncPending).length;
    notifyListeners();
  }

  void setFilterWard(String? wardId) {
    _selectedWardId = wardId;
    refreshGrievances();
  }

  void setFilterCategory(GrievanceCategory? cat) {
    _selectedCategory = cat;
    refreshGrievances();
  }

  void setFilterStatus(GrievanceStatus? status) {
    _selectedStatus = status;
    refreshGrievances();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    refreshGrievances();
  }

  void toggleLanguage() {
    _isHindi = !_isHindi;
    notifyListeners();
  }

  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  Future<void> switchRole(UserRole role) async {
    await _repository.switchUserRole(role);
    _currentUser = await _repository.getCurrentUser();
    await refreshGrievances();
    notifyListeners();
  }

  Future<Grievance> createGrievance({
    required String title,
    required String description,
    required GrievanceCategory category,
    required GrievancePriority priority,
    required String wardId,
    required String wardName,
    required String address,
    required String landmark,
    required double latitude,
    required double longitude,
    List<String> photoUrls = const [],
  }) async {
    final now = DateTime.now();
    final slaDuration = Duration(hours: (category.slaHours * priority.slaMultiplier).round());
    final isOffline = !_isOnline;

    final newGrievance = Grievance(
      id: 'GRV-${now.year}-${1000 + _grievances.length + 1}',
      title: title,
      description: description,
      category: category,
      status: GrievanceStatus.submitted,
      priority: priority,
      wardId: wardId,
      wardName: wardName,
      latitude: latitude,
      longitude: longitude,
      address: address,
      landmark: landmark,
      citizenId: _currentUser.id,
      citizenName: _currentUser.name,
      citizenPhone: _currentUser.phoneNumber,
      photoUrls: photoUrls,
      upvoteCount: 1,
      upvotedUserIds: [_currentUser.id],
      createdAt: now,
      updatedAt: now,
      slaDeadline: now.add(slaDuration),
      isOfflineSyncPending: isOffline,
      govtDocketNumber: 'JS-GOV-${now.year}-${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      govtDepartmentName: category.displayNameEn,
    );

    final saved = await _repository.submitGrievance(newGrievance);
    await refreshGrievances();
    return saved;
  }

  Future<void> upvote(String grievanceId) async {
    await _repository.toggleUpvote(grievanceId, _currentUser.id);
    await refreshGrievances();
  }

  Future<void> updateOfficerStatus({
    required String grievanceId,
    required GrievanceStatus newStatus,
    required String message,
    List<String> proofUrls = const [],
  }) async {
    await _repository.updateStatus(
      grievanceId: grievanceId,
      newStatus: newStatus,
      actorName: _currentUser.name,
      actorRole: _currentUser.role.label,
      message: message,
      proofUrls: proofUrls,
    );
    await refreshGrievances();
  }

  Future<void> verifyResolution({
    required String grievanceId,
    required int rating,
    required String feedback,
    required bool reopen,
  }) async {
    await _repository.verifyAndRate(
      grievanceId: grievanceId,
      rating: rating,
      feedback: feedback,
      reopen: reopen,
    );
    await refreshGrievances();
  }

  Future<void> verifyAndRateGrievance({
    required String grievanceId,
    required int rating,
    required String feedback,
    required bool reopen,
  }) =>
      verifyResolution(
        grievanceId: grievanceId,
        rating: rating,
        feedback: feedback,
        reopen: reopen,
      );

  Future<int> syncOfflineReports() async {
    final count = await _repository.syncOfflineQueue();
    await refreshGrievances();
    return count;
  }

  void toggleForumUpvote(String postId) {
    final index = _forumPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _forumPosts[index];
    final upvoters = List<String>.from(post.upvotedUserIds);

    if (upvoters.contains(_currentUser.id)) {
      upvoters.remove(_currentUser.id);
    } else {
      upvoters.add(_currentUser.id);
    }

    _forumPosts[index] = post.copyWith(upvotedUserIds: upvoters);
    notifyListeners();
  }

  void addForumPost(WardForumPost post) {
    _forumPosts.insert(0, post);
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
}
