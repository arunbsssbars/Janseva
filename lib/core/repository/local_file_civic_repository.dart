import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../enums/civic_enums.dart';
import '../models/grievance.dart';
import '../models/grievance_timeline.dart';
import '../models/user_profile.dart';
import '../models/ward.dart';
import 'civic_repository.dart';

class LocalFileCivicRepository implements ICivicRepository {
  final String? _customDirectoryPath;
  Directory? _storageDir;

  final List<Grievance> _grievances = [];
  final List<Ward> _wards = Ward.defaultWards();
  UserProfile _currentUser = UserProfile.defaultCitizen();
  final List<Grievance> _offlineQueue = [];

  bool _isInitialized = false;
  Completer<void>? _initCompleter;

  LocalFileCivicRepository({String? customDirectoryPath})
      : _customDirectoryPath = customDirectoryPath;

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();
    try {
      if (_customDirectoryPath != null) {
        _storageDir = Directory(_customDirectoryPath);
      } else if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
        _storageDir = Directory.systemTemp.createTempSync('janseva_test_storage_');
      } else {
        try {
          _storageDir = await getApplicationDocumentsDirectory();
        } catch (_) {
          // Fallback for tests or unsupported environments
          _storageDir = Directory.systemTemp.createTempSync('janseva_storage_');
        }
      }

      if (_storageDir != null && !_storageDir!.existsSync()) {
        _storageDir!.createSync(recursive: true);
      }

      await _loadOrSeedData();
      _isInitialized = true;
      _initCompleter!.complete();
    } catch (e) {
      debugPrint('LocalFileCivicRepository init error: $e');
      // Graceful fallback to seed in memory if IO errors
      _seedFallbackData();
      _isInitialized = true;
      _initCompleter!.complete();
    }
  }

  File? get _grievancesFile {
    if (_storageDir == null) return null;
    return File('${_storageDir!.path}/janseva_grievances.json');
  }

  File? get _userFile {
    if (_storageDir == null) return null;
    return File('${_storageDir!.path}/janseva_user.json');
  }

  File? get _offlineQueueFile {
    if (_storageDir == null) return null;
    return File('${_storageDir!.path}/janseva_offline_queue.json');
  }

  Future<void> _loadOrSeedData() async {
    // 1. Load or seed User Profile
    final userFile = _userFile;
    if (userFile != null && userFile.existsSync()) {
      try {
        final content = await userFile.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        _currentUser = UserProfile.fromJson(data);
      } catch (e) {
        debugPrint('Error reading user file: $e');
        _currentUser = UserProfile.defaultCitizen();
      }
    } else {
      _currentUser = UserProfile.defaultCitizen();
      await _saveUser();
    }

    // 2. Load or seed Grievances
    final grvFile = _grievancesFile;
    if (grvFile != null && grvFile.existsSync()) {
      try {
        final content = await grvFile.readAsString();
        final List<dynamic> list = jsonDecode(content);
        _grievances.clear();
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            _grievances.add(Grievance.fromJson(item));
          }
        }
      } catch (e) {
        debugPrint('Error reading grievances file: $e');
        _seedFallbackData();
      }
    } else {
      _seedFallbackData();
      await _saveGrievances();
    }

    // 3. Load Offline Queue
    final queueFile = _offlineQueueFile;
    if (queueFile != null && queueFile.existsSync()) {
      try {
        final content = await queueFile.readAsString();
        final List<dynamic> list = jsonDecode(content);
        _offlineQueue.clear();
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            _offlineQueue.add(Grievance.fromJson(item));
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _saveGrievances() async {
    final file = _grievancesFile;
    if (file == null) return;
    try {
      final jsonList = _grievances.map((g) => g.toJson()).toList();
      final content = jsonEncode(jsonList);
      // Atomic write via temp file
      final tempFile = File('${file.path}.tmp');
      await tempFile.writeAsString(content, flush: true);
      if (file.existsSync()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
    } catch (e) {
      debugPrint('Error saving grievances: $e');
    }
  }

  Future<void> _saveUser() async {
    final file = _userFile;
    if (file == null) return;
    try {
      final content = jsonEncode(_currentUser.toJson());
      final tempFile = File('${file.path}.tmp');
      await tempFile.writeAsString(content, flush: true);
      if (file.existsSync()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  Future<void> _saveOfflineQueue() async {
    final file = _offlineQueueFile;
    if (file == null) return;
    try {
      final jsonList = _offlineQueue.map((g) => g.toJson()).toList();
      final content = jsonEncode(jsonList);
      final tempFile = File('${file.path}.tmp');
      await tempFile.writeAsString(content, flush: true);
      if (file.existsSync()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
    } catch (e) {
      debugPrint('Error saving offline queue: $e');
    }
  }

  /// Direct convenience methods for persistence tests and background worker
  Future<List<Grievance>> loadGrievances() async {
    await ensureInitialized();
    return List.unmodifiable(_grievances);
  }

  Future<UserProfile> loadCurrentUser() async {
    await ensureInitialized();
    return _currentUser;
  }

  Future<void> saveGrievance(Grievance g) async {
    await ensureInitialized();
    final idx = _grievances.indexWhere((item) => item.id == g.id);
    if (idx != -1) {
      _grievances[idx] = g;
    } else {
      _grievances.insert(0, g);
    }
    await _saveGrievances();
  }

  Future<void> saveCurrentUser(UserProfile u) async {
    await ensureInitialized();
    _currentUser = u;
    await _saveUser();
  }

  Future<void> enqueueOffline(Grievance g) async {
    await ensureInitialized();
    _offlineQueue.add(g);
    await _saveOfflineQueue();
  }

  Future<List<Grievance>> getOfflineQueue() async {
    await ensureInitialized();
    return List.unmodifiable(_offlineQueue);
  }

  Future<void> clearOfflineQueue() async {
    await ensureInitialized();
    _offlineQueue.clear();
    await _saveOfflineQueue();
  }

  void _seedFallbackData() {
    _grievances.clear();
    final now = DateTime.now();
    _grievances.addAll([
      Grievance(
        id: 'GRV-2026-001',
        title: 'Dangerous Pothole on Civil Lines Main Road',
        description: 'Large 4-foot deep trench formed after pipeline excavation opposite State Bank branch. Two motorists slipped today.',
        category: GrievanceCategory.roadsAndPotholes,
        status: GrievanceStatus.inProgress,
        priority: GrievancePriority.emergency,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        latitude: 28.6738,
        longitude: 77.2185,
        address: 'Opposite State Bank, Main Mall Road, Civil Lines',
        landmark: 'SBI Building',
        citizenId: 'USR-001',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 9876543210',
        photoUrls: const ['https://picsum.photos/seed/pothole/400/300'],
        upvoteCount: 14,
        upvotedUserIds: const ['USR-002', 'USR-003'],
        createdAt: now.subtract(const Duration(hours: 18)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        slaDeadline: now.add(const Duration(hours: 6)),
        assignedOfficerName: 'Er. Rajesh Kumar, Executive Engineer PWD',
        resolutionNotes: 'Inspection completed. Hot-mix bitumen patching team dispatched with roller machine.',
        govtDocketNumber: 'ULB-311-2026-00142',
        govtDepartmentName: 'Public Works Department (PWD Road Division)',
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-01',
            grievanceId: 'GRV-2026-001',
            timestamp: now.subtract(const Duration(hours: 18)),
            status: GrievanceStatus.submitted,
            actorName: 'Aarav Patel',
            actorRole: 'Citizen',
            message: 'Grievance registered with geotagged photo proof.',
          ),
          GrievanceTimelineEvent(
            id: 'EVT-02',
            grievanceId: 'GRV-2026-001',
            timestamp: now.subtract(const Duration(hours: 12)),
            status: GrievanceStatus.triaged,
            actorName: 'AI Triager',
            actorRole: 'Automated Gateway',
            message: 'Routed to PWD Central Division based on GPS coordinate matching.',
          ),
          GrievanceTimelineEvent(
            id: 'EVT-03',
            grievanceId: 'GRV-2026-001',
            timestamp: now.subtract(const Duration(hours: 2)),
            status: GrievanceStatus.inProgress,
            actorName: 'Er. Rajesh Kumar',
            actorRole: 'Executive Engineer',
            message: 'Site inspection done. Road repair work order issued.',
          ),
        ],
      ),
      Grievance(
        id: 'GRV-2026-002',
        title: 'Overflowing Garbage Container and Open Dumping',
        description: 'Municipal garbage bin has not been cleared for 4 days. Waste spreading across the street, stray animals congregating.',
        category: GrievanceCategory.sanitationAndGarbage,
        status: GrievanceStatus.triaged,
        priority: GrievancePriority.high,
        wardId: 'W-01',
        wardName: 'Civil Lines',
        latitude: 28.6750,
        longitude: 77.2201,
        address: 'Sector 4 Market Corner, Civil Lines',
        landmark: 'Mother Dairy Booth',
        citizenId: 'USR-001',
        citizenName: 'Aarav Patel',
        citizenPhone: '+91 9876543210',
        photoUrls: const ['https://picsum.photos/seed/garbage/400/300'],
        upvoteCount: 7,
        upvotedUserIds: const ['USR-004'],
        createdAt: now.subtract(const Duration(hours: 36)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        slaDeadline: now.subtract(const Duration(hours: 12)), // Breached SLA
        assignedOfficerName: 'Sanjay Verma, Chief Sanitary Inspector',
        govtDocketNumber: 'SWM-1969-2026-00891',
        govtDepartmentName: 'Solid Waste Management & Swachhata Cell',
        timeline: [
          GrievanceTimelineEvent(
            id: 'EVT-04',
            grievanceId: 'GRV-2026-002',
            timestamp: now.subtract(const Duration(hours: 36)),
            status: GrievanceStatus.submitted,
            actorName: 'Aarav Patel',
            actorRole: 'Citizen',
            message: 'Garbage dump reported via Swachhata 1969 channel.',
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
    await ensureInitialized();
    return _grievances.where((g) {
      if (wardId != null && g.wardId != wardId) return false;
      if (category != null && g.category != category) return false;
      if (status != null && g.status != status) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchTitle = g.title.toLowerCase().contains(q);
        final matchDesc = g.description.toLowerCase().contains(q);
        final matchLoc = g.address.toLowerCase().contains(q);
        final matchId = g.id.toLowerCase().contains(q);
        final matchDocket = g.govtDocketNumber?.toLowerCase().contains(q) ?? false;
        if (!matchTitle && !matchDesc && !matchLoc && !matchId && !matchDocket) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<Grievance?> getGrievanceById(String id) async {
    await ensureInitialized();
    try {
      return _grievances.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Grievance> submitGrievance(Grievance grievance) async {
    await ensureInitialized();
    _grievances.insert(0, grievance);
    if (grievance.isOfflineSyncPending) {
      _offlineQueue.add(grievance);
      await _saveOfflineQueue();
    }
    _currentUser = _currentUser.copyWith(
      totalReportsFiled: _currentUser.totalReportsFiled + 1,
    );
    await _saveGrievances();
    await _saveUser();
    return grievance;
  }

  @override
  Future<Grievance> toggleUpvote(String grievanceId, String userId) async {
    await ensureInitialized();
    final idx = _grievances.indexWhere((g) => g.id == grievanceId);
    if (idx == -1) throw Exception('Grievance $grievanceId not found');

    final current = _grievances[idx];
    final hasUpvoted = current.upvotedUserIds.contains(userId);
    final newUpvoted = List<String>.from(current.upvotedUserIds);
    int newCount = current.upvoteCount;

    if (hasUpvoted) {
      newUpvoted.remove(userId);
      newCount = (newCount - 1).clamp(0, 999999);
    } else {
      newUpvoted.add(userId);
      newCount++;
    }

    final updated = current.copyWith(
      upvoteCount: newCount,
      upvotedUserIds: newUpvoted,
    );
    _grievances[idx] = updated;
    await _saveGrievances();
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
    await ensureInitialized();
    final idx = _grievances.indexWhere((g) => g.id == grievanceId);
    if (idx == -1) throw Exception('Grievance $grievanceId not found');

    final current = _grievances[idx];
    final newTimeline = List<GrievanceTimelineEvent>.from(current.timeline)
      ..add(
        GrievanceTimelineEvent(
          id: 'EVT-${DateTime.now().millisecondsSinceEpoch}',
          grievanceId: grievanceId,
          timestamp: DateTime.now(),
          status: newStatus,
          actorName: actorName,
          actorRole: actorRole,
          message: message,
          proofUrls: proofUrls,
        ),
      );

    final updated = current.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      resolvedAt: newStatus == GrievanceStatus.resolved ? DateTime.now() : current.resolvedAt,
      resolutionNotes: message,
      resolutionPhotoUrls: proofUrls.isNotEmpty ? proofUrls : current.resolutionPhotoUrls,
      timeline: newTimeline,
    );

    _grievances[idx] = updated;
    await _saveGrievances();
    return updated;
  }

  @override
  Future<Grievance> verifyAndRate({
    required String grievanceId,
    required int rating,
    required String feedback,
    required bool reopen,
  }) async {
    await ensureInitialized();
    final idx = _grievances.indexWhere((g) => g.id == grievanceId);
    if (idx == -1) throw Exception('Grievance $grievanceId not found');

    final current = _grievances[idx];
    final newStatus = reopen ? GrievanceStatus.reopened : GrievanceStatus.verifiedClosed;
    final newTimeline = List<GrievanceTimelineEvent>.from(current.timeline)
      ..add(
        GrievanceTimelineEvent(
          id: 'EVT-${DateTime.now().millisecondsSinceEpoch}',
          grievanceId: grievanceId,
          timestamp: DateTime.now(),
          status: newStatus,
          actorName: _currentUser.name,
          actorRole: 'Citizen Quality Auditor',
          message: reopen
              ? 'Citizen rejected resolution: "$feedback". Docket escalated to Municipal Vigilance.'
              : 'Citizen verified resolution: Rated $rating/5 stars. "$feedback"',
        ),
      );

    final updated = current.copyWith(
      status: newStatus,
      citizenRating: rating,
      citizenFeedback: feedback,
      updatedAt: DateTime.now(),
      timeline: newTimeline,
    );

    _grievances[idx] = updated;
    await _saveGrievances();
    return updated;
  }

  @override
  Future<int> syncOfflineQueue() async {
    await ensureInitialized();
    final count = _offlineQueue.length;
    for (final queued in _offlineQueue) {
      final idx = _grievances.indexWhere((g) => g.id == queued.id);
      if (idx != -1) {
        _grievances[idx] = _grievances[idx].copyWith(isOfflineSyncPending: false);
      }
    }
    _offlineQueue.clear();
    await _saveOfflineQueue();
    await _saveGrievances();
    return count;
  }

  @override
  Future<List<Ward>> getWards() async {
    await ensureInitialized();
    return _wards;
  }

  @override
  Future<UserProfile> getCurrentUser() async {
    await ensureInitialized();
    return _currentUser;
  }

  @override
  Future<void> switchUserRole(UserRole role) async {
    await ensureInitialized();
    _currentUser = _currentUser.copyWith(role: role);
    await _saveUser();
  }
}
