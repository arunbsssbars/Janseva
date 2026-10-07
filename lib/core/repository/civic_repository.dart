import 'dart:async';
import '../enums/civic_enums.dart';
import '../models/grievance.dart';
import '../models/grievance_timeline.dart';
import '../models/user_profile.dart';
import '../models/ward.dart';

abstract class ICivicRepository {
  Future<List<Grievance>> getGrievances({
    String? wardId,
    GrievanceCategory? category,
    GrievanceStatus? status,
    String? searchQuery,
  });

  Future<Grievance?> getGrievanceById(String id);

  Future<Grievance> submitGrievance(Grievance grievance);

  Future<Grievance> toggleUpvote(String grievanceId, String userId);

  Future<Grievance> updateStatus({
    required String grievanceId,
    required GrievanceStatus newStatus,
    required String actorName,
    required String actorRole,
    required String message,
    List<String> proofUrls,
  });

  Future<Grievance> verifyAndRate({
    required String grievanceId,
    required int rating,
    required String feedback,
    required bool reopen,
  });

  Future<int> syncOfflineQueue();

  Future<List<Ward>> getWards();

  Future<UserProfile> getCurrentUser();

  Future<void> switchUserRole(UserRole role);
}

class InMemoryCivicRepository implements ICivicRepository {
  final List<Grievance> _grievances = [];
  final List<Ward> _wards = Ward.defaultWards();
  UserProfile _currentUser = UserProfile.defaultCitizen();
  final List<Grievance> _offlineQueue = [];

  InMemoryCivicRepository() {
    _seedInitialData();
  }

  void _seedInitialData() {
    final now = DateTime.now();
    _grievances.addAll([
      Grievance(
        id: 'GRV-2026-101',
        title: 'Deep crater pothole near metro pillar 42',
        description:
            'A large pothole has opened up in the middle lane causing severe two-wheeler skids during evening traffic.',
        category: GrievanceCategory.roadsAndPotholes,
        status: GrievanceStatus.inProgress,
        priority: GrievancePriority.high,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'MG Road, Near Metro Pillar 42',
        landmark: 'Near City Hospital Gate 2',
        citizenId: 'USR-CITIZEN-01',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 98765 43210',
        photoUrls: ['https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=600'],
        upvoteCount: 18,
        upvotedUserIds: ['USR-CITIZEN-01', 'USR-02', 'USR-03'],
        createdAt: now.subtract(const Duration(hours: 14)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        slaDeadline: now.add(const Duration(hours: 34)),
        assignedOfficerName: 'Sanjay Verma (Ward Officer)',
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-101-1',
            grievanceId: 'GRV-2026-101',
            status: GrievanceStatus.submitted,
            timestamp: now.subtract(const Duration(hours: 14)),
            actorName: 'Aarav Patel',
            actorRole: 'Citizen',
            message: 'Grievance submitted via JanSeva.',
          ),
          GrievanceTimelineEvent(
            id: 'EVT-101-2',
            grievanceId: 'GRV-2026-101',
            status: GrievanceStatus.triaged,
            timestamp: now.subtract(const Duration(hours: 10)),
            actorName: 'Central Dispatch System',
            actorRole: 'Automated Triaging',
            message: 'Assigned to Civil Lines Ward Maintenance Dept.',
          ),
          GrievanceTimelineEvent(
            id: 'EVT-101-3',
            grievanceId: 'GRV-2026-101',
            status: GrievanceStatus.inProgress,
            timestamp: now.subtract(const Duration(hours: 3)),
            actorName: 'Sanjay Verma',
            actorRole: 'Ward Officer',
            message: 'Road repair team and asphalt patcher dispatched to site.',
          ),
        ],
      ),
      Grievance(
        id: 'GRV-2026-102',
        title: 'Overflowing community garbage bin in Block C',
        description:
            'Garbage container has not been cleared for 3 days. Foul smell and stray dogs scavenging around the school zone.',
        category: GrievanceCategory.sanitationAndGarbage,
        status: GrievanceStatus.resolved,
        priority: GrievancePriority.medium,
        wardId: 'W-02',
        wardName: 'Gandhi Nagar',
        latitude: 28.6512,
        longitude: 77.2614,
        address: 'Block C Market Square',
        landmark: 'Opposite Government Primary School',
        citizenId: 'USR-CITIZEN-01',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 98765 43210',
        photoUrls: ['https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=600'],
        upvoteCount: 9,
        upvotedUserIds: ['USR-CITIZEN-01'],
        createdAt: now.subtract(const Duration(hours: 28)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        slaDeadline: now.subtract(const Duration(hours: 4)),
        resolvedAt: now.subtract(const Duration(hours: 4)),
        assignedOfficerName: 'Anita Mehra (Ward Officer)',
        resolutionNotes:
            'Dumpster emptied and sanitized with lime powder spray by Sanitation Team #4.',
        resolutionPhotoUrls: ['https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=600'],
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-102-1',
            grievanceId: 'GRV-2026-102',
            status: GrievanceStatus.submitted,
            timestamp: now.subtract(const Duration(hours: 28)),
            actorName: 'Aarav Patel',
            actorRole: 'Citizen',
            message: 'Reported garbage overflow.',
          ),
          GrievanceTimelineEvent(
            id: 'EVT-102-2',
            grievanceId: 'GRV-2026-102',
            status: GrievanceStatus.resolved,
            timestamp: now.subtract(const Duration(hours: 4)),
            actorName: 'Anita Mehra',
            actorRole: 'Ward Officer',
            message: 'Area cleared and washed. Awaiting citizen verification.',
          ),
        ],
      ),
      Grievance(
        id: 'GRV-2026-103',
        title: 'Broken drinking water distribution pipeline',
        description:
            'Clean drinking water gushing onto the road since 6 AM. Several households facing zero water pressure.',
        category: GrievanceCategory.waterSupply,
        status: GrievanceStatus.triaged,
        priority: GrievancePriority.emergency,
        wardId: 'W-03',
        wardName: 'Industrial Area Phase 1',
        latitude: 28.5890,
        longitude: 77.2180,
        address: '4th Cross Street, Ward 3',
        landmark: 'Near Water Booster Station',
        citizenId: 'USR-04',
        citizenName: 'Ramesh Gupta',
        citizenPhone: '+91 98222 33445',
        photoUrls: ['https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600'],
        upvoteCount: 24,
        upvotedUserIds: ['USR-04', 'USR-05'],
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        slaDeadline: now.add(const Duration(hours: 4)),
        assignedOfficerName: 'Vikram Joshi (Ward Officer)',
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-103-1',
            grievanceId: 'GRV-2026-103',
            status: GrievanceStatus.submitted,
            timestamp: now.subtract(const Duration(hours: 2)),
            actorName: 'Ramesh Gupta',
            actorRole: 'Citizen',
            message: 'Emergency pipeline burst reported.',
          ),
        ],
      ),
      Grievance(
        id: 'GRV-2026-104',
        title: 'Dark streetlights along Girl Senior School Lane',
        description:
            '5 consecutive streetlights non-functional for past week, posing safety concerns for pedestrians at night.',
        category: GrievanceCategory.electricityAndStreetlights,
        status: GrievanceStatus.verifiedClosed,
        priority: GrievancePriority.medium,
        wardId: 'W-04',
        wardName: 'Model Town',
        latitude: 28.7010,
        longitude: 77.1950,
        address: 'Lane 8, Model Town East',
        landmark: 'Opposite Community Center',
        citizenId: 'USR-CITIZEN-01',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 98765 43210',
        photoUrls: [],
        upvoteCount: 31,
        upvotedUserIds: ['USR-CITIZEN-01'],
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 1)),
        slaDeadline: now.subtract(const Duration(days: 2)),
        resolvedAt: now.subtract(const Duration(days: 2)),
        assignedOfficerName: 'Priya Kulkarni (Ward Officer)',
        resolutionNotes: 'Faulty underground cable repaired and all 5 LED fixtures replaced.',
        citizenRating: 5,
        citizenFeedback: 'Quick and satisfactory resolution! Street is well lit now.',
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-104-1',
            grievanceId: 'GRV-2026-104',
            status: GrievanceStatus.verifiedClosed,
            timestamp: now.subtract(const Duration(days: 1)),
            actorName: 'Aarav Patel',
            actorRole: 'Citizen',
            message: 'Citizen confirmed resolution with 5-star rating.',
          ),
        ],
      ),
    ]);
  }

  @override
  Future<List<Grievance>> getGrievances({
    String? wardId,
    GrievanceCategory? category,
    GrievanceStatus? status,
    String? searchQuery,
  }) async {
    return _grievances.where((g) {
      if (wardId != null && wardId.isNotEmpty && g.wardId != wardId) return false;
      if (category != null && g.category != category) return false;
      if (status != null && g.status != status) return false;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matches = g.title.toLowerCase().contains(q) ||
            g.description.toLowerCase().contains(q) ||
            g.address.toLowerCase().contains(q) ||
            g.id.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Grievance?> getGrievanceById(String id) async {
    try {
      return _grievances.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Grievance> submitGrievance(Grievance grievance) async {
    if (grievance.isOfflineSyncPending) {
      _offlineQueue.add(grievance);
    }
    _grievances.insert(0, grievance);
    return grievance;
  }

  @override
  Future<Grievance> toggleUpvote(String grievanceId, String userId) async {
    final index = _grievances.indexWhere((g) => g.id == grievanceId);
    if (index == -1) throw Exception('Grievance not found');

    final existing = _grievances[index];
    final hasUpvoted = existing.upvotedUserIds.contains(userId);

    final updatedUpvotedUsers = List<String>.from(existing.upvotedUserIds);
    int newCount = existing.upvoteCount;

    if (hasUpvoted) {
      updatedUpvotedUsers.remove(userId);
      newCount = (newCount - 1).clamp(0, 99999);
    } else {
      updatedUpvotedUsers.add(userId);
      newCount += 1;
    }

    final updated = existing.copyWith(
      upvoteCount: newCount,
      upvotedUserIds: updatedUpvotedUsers,
    );

    _grievances[index] = updated;
    return updated;
  }

  @override
  Future<Grievance> updateStatus({
    required String grievanceId,
    required GrievanceStatus newStatus,
    required String actorName,
    required String actorRole,
    required String message,
    List<String> proofUrls = const [],
  }) async {
    final index = _grievances.indexWhere((g) => g.id == grievanceId);
    if (index == -1) throw Exception('Grievance not found');

    final existing = _grievances[index];
    final now = DateTime.now();

    final newEvent = GrievanceTimelineEvent(
      id: 'EVT-${now.millisecondsSinceEpoch}',
      grievanceId: grievanceId,
      status: newStatus,
      timestamp: now,
      actorName: actorName,
      actorRole: actorRole,
      message: message,
      proofUrls: proofUrls,
    );

    final updatedTimeline = List<GrievanceTimelineEvent>.from(existing.timeline)..add(newEvent);

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: now,
      resolvedAt: newStatus == GrievanceStatus.resolved ? now : existing.resolvedAt,
      resolutionNotes: newStatus == GrievanceStatus.resolved ? message : existing.resolutionNotes,
      resolutionPhotoUrls:
          proofUrls.isNotEmpty ? proofUrls : existing.resolutionPhotoUrls,
      timeline: updatedTimeline,
    );

    _grievances[index] = updated;
    return updated;
  }

  @override
  Future<Grievance> verifyAndRate({
    required String grievanceId,
    required int rating,
    required String feedback,
    required bool reopen,
  }) async {
    final index = _grievances.indexWhere((g) => g.id == grievanceId);
    if (index == -1) throw Exception('Grievance not found');

    final existing = _grievances[index];
    final now = DateTime.now();

    final newStatus = reopen ? GrievanceStatus.reopened : GrievanceStatus.verifiedClosed;
    final event = GrievanceTimelineEvent(
      id: 'EVT-${now.millisecondsSinceEpoch}',
      grievanceId: grievanceId,
      status: newStatus,
      timestamp: now,
      actorName: _currentUser.name,
      actorRole: 'Citizen',
      message: reopen
          ? 'Reopened by citizen: $feedback'
          : 'Verified & rated $rating★: $feedback',
    );

    final updatedTimeline = List<GrievanceTimelineEvent>.from(existing.timeline)..add(event);

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: now,
      citizenRating: reopen ? null : rating,
      citizenFeedback: feedback,
      timeline: updatedTimeline,
    );

    _grievances[index] = updated;
    return updated;
  }

  @override
  Future<int> syncOfflineQueue() async {
    final count = _offlineQueue.length;
    for (final queued in _offlineQueue) {
      final index = _grievances.indexWhere((g) => g.id == queued.id);
      if (index != -1) {
        _grievances[index] = _grievances[index].copyWith(isOfflineSyncPending: false);
      }
    }
    _offlineQueue.clear();
    return count;
  }

  @override
  Future<List<Ward>> getWards() async => _wards;

  @override
  Future<UserProfile> getCurrentUser() async => _currentUser;

  @override
  Future<void> switchUserRole(UserRole role) async {
    if (role == UserRole.wardOfficer || role == UserRole.departmentAdmin) {
      _currentUser = UserProfile.defaultOfficer();
    } else {
      _currentUser = UserProfile.defaultCitizen();
    }
  }
}
