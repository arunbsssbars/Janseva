enum CivicNotificationType {
  statusUpdate(
    code: 'STATUS_UPDATE',
    titleEn: 'Status Update',
    titleHi: 'स्थिति अपडेट',
    colorHex: 0xFF2563EB,
  ),
  slaBreach(
    code: 'SLA_BREACH',
    titleEn: 'SLA Breach Notice',
    titleHi: 'समय सीमा उल्लंघन',
    colorHex: 0xFFDC2626,
  ),
  officerAssigned(
    code: 'OFFICER_ASSIGNED',
    titleEn: 'Field Officer Assigned',
    titleHi: 'अधिकारी नियुक्त',
    colorHex: 0xFF7C3AED,
  ),
  verificationRequired(
    code: 'VERIFICATION_REQUIRED',
    titleEn: 'Citizen Verification Pending',
    titleHi: 'सत्यापन आवश्यक',
    colorHex: 0xFF059669,
  ),
  communityNotice(
    code: 'WARD_NOTICE',
    titleEn: 'Ward Bulletin',
    titleHi: 'वार्ड सूचना',
    colorHex: 0xFFD97706,
  );

  const CivicNotificationType({
    required this.code,
    required this.titleEn,
    required this.titleHi,
    required this.colorHex,
  });

  final String code;
  final String titleEn;
  final String titleHi;
  final int colorHex;
}

class CivicNotification {
  final String id;
  final String title;
  final String titleHi;
  final String message;
  final String messageHi;
  final CivicNotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? targetGrievanceId;

  const CivicNotification({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.message,
    required this.messageHi,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.targetGrievanceId,
  });

  CivicNotification copyWith({
    String? id,
    String? title,
    String? titleHi,
    String? message,
    String? messageHi,
    CivicNotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? targetGrievanceId,
  }) {
    return CivicNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      titleHi: titleHi ?? this.titleHi,
      message: message ?? this.message,
      messageHi: messageHi ?? this.messageHi,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      targetGrievanceId: targetGrievanceId ?? this.targetGrievanceId,
    );
  }

  static List<CivicNotification> mockNotifications() {
    final now = DateTime.now();
    return [
      CivicNotification(
        id: 'notif-1',
        title: 'Work Completed: Pothole Rectification',
        titleHi: 'कार्य पूर्ण: गड्ढा मरम्मत',
        message: 'Repair work on Main Market Road has been completed. Please inspect and rate.',
        messageHi: 'मुख्य बाजार मार्ग पर मरम्मत कार्य पूरा हो गया है। कृपया समीक्षा करें।',
        type: CivicNotificationType.verificationRequired,
        timestamp: now.subtract(const Duration(minutes: 35)),
        targetGrievanceId: 'G-102',
        isRead: false,
      ),
      CivicNotification(
        id: 'notif-2',
        title: 'Tier-1 SLA Breach Escalation',
        titleHi: 'स्तर-1 एसएलए उल्लंघन अधिसूचना',
        message: 'Drainage overflow report at Civil Lines has exceeded 24 hours. Re-routed to Executive Engineer.',
        messageHi: 'सिविल लाइन्स में जलभराव की शिकायत 24 घंटे पार कर गई है। अधिशासी अभियंता को भेजी गई।',
        type: CivicNotificationType.slaBreach,
        timestamp: now.subtract(const Duration(hours: 3)),
        targetGrievanceId: 'G-101',
        isRead: false,
      ),
      CivicNotification(
        id: 'notif-3',
        title: 'Junior Engineer Assigned',
        titleHi: 'कनिष्ठ अभियंता नियुक्त',
        message: 'Er. Rajesh Kumar has been designated to lead site inspection.',
        messageHi: 'इंजीनियर राजेश कुमार को स्थल निरीक्षण हेतु नियुक्त किया गया है।',
        type: CivicNotificationType.officerAssigned,
        timestamp: now.subtract(const Duration(hours: 12)),
        targetGrievanceId: 'G-103',
        isRead: true,
      ),
      CivicNotification(
        id: 'notif-4',
        title: 'Scheduled Water Supply Maintenance',
        titleHi: 'निर्धारित जल आपूर्ति रखरखाव',
        message: 'Booster pump maintenance in Ward 1 tomorrow from 2 PM to 6 PM.',
        messageHi: 'वार्ड 1 में कल दोपहर 2 बजे से शाम 6 बजे तक बूस्टर पंप रखरखाव।',
        type: CivicNotificationType.communityNotice,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }
}
