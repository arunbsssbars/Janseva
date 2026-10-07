import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/models/grievance.dart';
import 'package:janseva_mobile/core/models/pan_india_directory.dart';
import 'package:janseva_mobile/core/repository/local_file_civic_repository.dart';
import 'package:janseva_mobile/core/services/native_channel_launcher.dart';
import 'package:janseva_mobile/core/services/rti_petition_generator.dart';

void main() {
  group('PanIndiaDirectory Tests', () {
    test('contains key metro municipal corporations', () {
      const corps = PanIndiaDirectory.corporations;
      expect(corps.isNotEmpty, isTrue);
      expect(corps.any((c) => c.id == 'MCD_DELHI'), isTrue);
      expect(corps.any((c) => c.id == 'BMC_MUMBAI'), isTrue);
      expect(corps.any((c) => c.id == 'BBMP_BENGALURU'), isTrue);
      expect(corps.any((c) => c.id == 'LNN_LUCKNOW'), isTrue);
    });

    test('findByPincodeOrLocality returns correct corporation or fallback', () {
      final mcd = PanIndiaDirectory.findByPincodeOrLocality('Delhi');
      expect(mcd.id, equals('MCD_DELHI'));

      final bmc = PanIndiaDirectory.findByPincodeOrLocality('Mumbai');
      expect(bmc.id, equals('BMC_MUMBAI'));

      final lnn = PanIndiaDirectory.findByPincodeOrLocality('Hazratganj');
      expect(lnn.id, equals('LNN_LUCKNOW'));

      final fallback = PanIndiaDirectory.findByPincodeOrLocality('UnknownTown');
      expect(fallback.id, equals(PanIndiaDirectory.defaultCorporation.id));
    });

    test('corporations contain official emergency and utility numbers', () {
      final delhi = PanIndiaDirectory.findByPincodeOrLocality('Delhi');
      expect(delhi.cmHelplineNumber, equals('1031'));
      expect(delhi.discomHelpline, equals('1912'));
      expect(delhi.jalBoardHelpline, equals('1916'));

      final lucknow = PanIndiaDirectory.findByPincodeOrLocality('Lucknow');
      expect(lucknow.cmHelplineNumber, equals('1076'));
      expect(lucknow.municipalHelpline, equals('1533'));
    });
  });

  group('RtiPetitionGenerator Tests', () {
    test('generates valid statutory Section 6(1) RTI draft', () {
      final now = DateTime.now();
      final grievance = Grievance(
        id: 'GRV-TEST-001',
        title: 'Broken Sewer Line and Hazardous Stagnant Sewage',
        description: 'Open sewage flowing on main street for 10 days causing dengue hazard.',
        category: GrievanceCategory.sewageAndDrainage,
        priority: GrievancePriority.emergency,
        status: GrievanceStatus.inProgress,
        wardId: 'WARD-05',
        wardName: 'Civil Lines',
        address: '12 MG Road',
        landmark: 'Near Govt High School',
        latitude: 28.6139,
        longitude: 77.2090,
        citizenId: 'USR-TEST',
        citizenName: 'Ramesh Kumar',
        citizenPhone: '9876543210',
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 2)),
        slaDeadline: now.subtract(const Duration(days: 3)),
        upvotedUserIds: const [],
        photoUrls: const [],
        timeline: const [],
      );

      final draft = RtiPetitionGenerator.generateDraft(
        grievance: grievance,
        citizenName: 'Ramesh Kumar',
        citizenAddress: '12 MG Road, Ward 5, Delhi',
        citizenPhone: '9876543210',
      );

      final fullText = draft.fullDraftText;
      expect(fullText.contains('RIGHT TO INFORMATION ACT, 2005'), isTrue);
      expect(fullText.contains('SECTION 6(1)'), isTrue);
      expect(fullText.contains('GRV-TEST-001'), isTrue);
      expect(fullText.contains('Ramesh Kumar'), isTrue);
      expect(draft.queries.length, equals(5));
      expect(draft.queries.any((q) => q.contains('Work Order')), isTrue);
      expect(draft.queries.any((q) => q.contains('Junior Engineer')), isTrue);
    });
  });

  group('NativeChannelLauncher Tests', () {
    test('generates compliant WhatsApp message text', () {
      final now = DateTime.now();
      final grievance = Grievance(
        id: 'GRV-TEST-002',
        title: 'Dangerous Pothole on Flyover',
        description: 'Massive crater causing two-wheelers to slip.',
        category: GrievanceCategory.roadsAndPotholes,
        priority: GrievancePriority.high,
        status: GrievanceStatus.submitted,
        wardId: 'WARD-10',
        wardName: 'Indira Nagar',
        address: 'Flyover ramp',
        landmark: 'Sector 4',
        latitude: 26.8467,
        longitude: 80.9462,
        citizenId: 'USR-TEST',
        citizenName: 'Pooja Sharma',
        citizenPhone: '9876543211',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(hours: 48)),
        upvotedUserIds: const [],
        photoUrls: const [],
        timeline: const [],
      );

      final text = NativeChannelLauncher.buildWhatsAppMessage(grievance);
      expect(text.contains('CITIZEN GRIEVANCE DOSSIER'), isTrue);
      expect(text.contains('GRV-TEST-002'), isTrue);
      expect(text.contains('Dangerous Pothole on Flyover'), isTrue);
      expect(text.contains('Flyover ramp'), isTrue);
    });
  });

  group('LocalFileCivicRepository Persistence Tests', () {
    late Directory tempDir;
    late LocalFileCivicRepository repo;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('janseva_test_');
      repo = LocalFileCivicRepository(customDirectoryPath: tempDir.path);
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('initializes default grievances and user profile on disk', () async {
      final grievances = await repo.loadGrievances();
      expect(grievances.isNotEmpty, isTrue);

      final user = await repo.loadCurrentUser();
      expect(user.id.isNotEmpty, isTrue);

      final grievancesFile = File('${tempDir.path}/janseva_grievances.json');
      final userFile = File('${tempDir.path}/janseva_user.json');
      expect(await grievancesFile.exists(), isTrue);
      expect(await userFile.exists(), isTrue);
    });

    test('adds grievance and persists cleanly across reload', () async {
      await repo.loadGrievances();

      final now = DateTime.now();
      final newGrievance = Grievance(
        id: 'GRV-PERSIST-999',
        title: 'Leaking water pipeline',
        description: 'Water gushing out at junction.',
        category: GrievanceCategory.waterSupply,
        priority: GrievancePriority.high,
        status: GrievanceStatus.submitted,
        wardId: 'W-01',
        wardName: 'Alambagh',
        address: 'Metro pillar 42',
        landmark: 'Bus stand',
        latitude: 26.8,
        longitude: 80.9,
        citizenId: 'USR-TEST',
        citizenName: 'Aarav Patel',
        citizenPhone: '9876543210',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(days: 2)),
        upvotedUserIds: const [],
        photoUrls: const [],
        timeline: const [],
      );

      await repo.saveGrievance(newGrievance);

      // Create a fresh instance reading from the same directory to verify disk persistence
      final freshRepo = LocalFileCivicRepository(customDirectoryPath: tempDir.path);
      final loaded = await freshRepo.loadGrievances();

      final found = loaded.firstWhere((g) => g.id == 'GRV-PERSIST-999');
      expect(found.title, equals('Leaking water pipeline'));
      expect(found.category, equals(GrievanceCategory.waterSupply));
    });

    test('updates user profile and persists to disk', () async {
      final user = await repo.loadCurrentUser();
      final updatedUser = user.copyWith(totalReportsFiled: user.totalReportsFiled + 5);
      await repo.saveCurrentUser(updatedUser);

      final freshRepo = LocalFileCivicRepository(customDirectoryPath: tempDir.path);
      final reloadedUser = await freshRepo.loadCurrentUser();
      expect(reloadedUser.totalReportsFiled, equals(user.totalReportsFiled + 5));
    });

    test('enqueues and clears offline queue correctly', () async {
      await repo.loadGrievances();

      final now = DateTime.now();
      final offlineItem = Grievance(
        id: 'GRV-OFFLINE-001',
        title: 'Offline reported pothole',
        description: 'No internet when reported',
        category: GrievanceCategory.roadsAndPotholes,
        priority: GrievancePriority.medium,
        status: GrievanceStatus.submitted,
        wardId: 'W-02',
        wardName: 'Hazratganj',
        address: 'Park road',
        landmark: 'Post office',
        latitude: 26.85,
        longitude: 80.95,
        citizenId: 'USR-TEST',
        citizenName: 'Aarav Patel',
        citizenPhone: '9876543210',
        createdAt: now,
        updatedAt: now,
        slaDeadline: now.add(const Duration(days: 3)),
        upvotedUserIds: const [],
        photoUrls: const [],
        timeline: const [],
      );

      await repo.enqueueOffline(offlineItem);
      final queue = await repo.getOfflineQueue();
      expect(queue.length, equals(1));
      expect(queue.first.id, equals('GRV-OFFLINE-001'));

      await repo.clearOfflineQueue();
      final emptyQueue = await repo.getOfflineQueue();
      expect(emptyQueue.isEmpty, isTrue);
    });
  });
}
