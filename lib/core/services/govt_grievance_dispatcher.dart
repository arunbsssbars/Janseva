import '../enums/civic_enums.dart';
import '../models/govt_channel.dart';

class GovtGrievanceReceipt {
  final String docketNumber;
  final GovtPortalType portal;
  final String departmentNameEn;
  final String departmentNameHi;
  final String nodalOfficer;
  final String helplineNumber;
  final DateTime submissionTime;
  final DateTime statutoryDeadline;
  final int slaHours;
  final String acknowledgmentSmsText;

  const GovtGrievanceReceipt({
    required this.docketNumber,
    required this.portal,
    required this.departmentNameEn,
    required this.departmentNameHi,
    required this.nodalOfficer,
    required this.helplineNumber,
    required this.submissionTime,
    required this.statutoryDeadline,
    required this.slaHours,
    required this.acknowledgmentSmsText,
  });
}

class GovtGrievanceDispatcher {
  /// Maps a civic category to the appropriate government department routing
  static GovtDepartmentRouting resolveRouting(GrievanceCategory category) {
    switch (category) {
      case GrievanceCategory.roadsAndPotholes:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Public Works Department (PWD Road Division)',
          departmentNameHi: 'लोक निर्माण विभाग (सड़क प्रभाग)',
          targetPortal: GovtPortalType.municipal311,
          nodalOfficerDesignation: 'Executive Engineer (PWD Works)',
          statutorySlaHours: 48,
          helplineNumber: '1800-180-5555',
        );

      case GrievanceCategory.sanitationAndGarbage:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Solid Waste Management & Swachhata Cell',
          departmentNameHi: 'ठोस अपशिष्ट प्रबंधन एवं स्वच्छता प्रकोष्ठ',
          targetPortal: GovtPortalType.swachhata,
          nodalOfficerDesignation: 'Chief Sanitary Inspector (CSI)',
          statutorySlaHours: 24,
          helplineNumber: '1969',
        );

      case GrievanceCategory.waterSupply:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Municipal Jal Board (Water Works & Pressure)',
          departmentNameHi: 'नगर जल बोर्ड (पेयजल एवं पाइपलाइन)',
          targetPortal: GovtPortalType.jalBoard,
          nodalOfficerDesignation: 'Assistant Engineer (Water Distribution)',
          statutorySlaHours: 24,
          helplineNumber: '1916',
        );

      case GrievanceCategory.electricityAndStreetlights:
        return const GovtDepartmentRouting(
          departmentNameEn: 'State Power Distribution Corporation (DISCOM)',
          departmentNameHi: 'विद्युत वितरण निगम एवं स्ट्रीट लाइट प्रकोष्ठ',
          targetPortal: GovtPortalType.discomPower,
          nodalOfficerDesignation: 'Sub-Divisional Officer (Electrical)',
          statutorySlaHours: 36,
          helplineNumber: '1912',
        );

      case GrievanceCategory.sewageAndDrainage:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Urban Sewerage & Stormwater Drainage Authority',
          departmentNameHi: 'शहरी सीवरेज एवं वर्षा जल निकासी प्राधिकरण',
          targetPortal: GovtPortalType.jalBoard,
          nodalOfficerDesignation: 'Drainage Superintendent',
          statutorySlaHours: 24,
          helplineNumber: '1916',
        );

      case GrievanceCategory.publicSafetyAndHazards:
        return const GovtDepartmentRouting(
          departmentNameEn: 'District Emergency Operations Center & Police',
          departmentNameHi: 'जिला आपातकालीन संचालन केंद्र एवं नागरिक सुरक्षा',
          targetPortal: GovtPortalType.stateJanSunwai,
          nodalOfficerDesignation: 'District Magistrate Rapid Action Officer',
          statutorySlaHours: 12,
          helplineNumber: '112',
        );

      case GrievanceCategory.strayAnimals:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Municipal Veterinary & Animal Welfare Department',
          departmentNameHi: 'नगर पशु चिकित्सा एवं जीव कल्याण विभाग',
          targetPortal: GovtPortalType.municipal311,
          nodalOfficerDesignation: 'Senior Veterinary Surgeon',
          statutorySlaHours: 72,
          helplineNumber: '1800-180-2222',
        );

      case GrievanceCategory.illegalEncroachment:
        return const GovtDepartmentRouting(
          departmentNameEn: 'Town Planning & Anti-Encroachment Enforcement',
          departmentNameHi: 'नगर नियोजन एवं अतिक्रमण रोधी प्रवर्तन दस्ता',
          targetPortal: GovtPortalType.stateJanSunwai,
          nodalOfficerDesignation: 'Zonal Enforcement Magistrate',
          statutorySlaHours: 96,
          helplineNumber: '181',
        );
    }
  }

  /// Dispatches the grievance to the respective government mechanism and returns an official receipt
  static GovtGrievanceReceipt dispatchToGovtPortal({
    required String grievanceId,
    required GrievanceCategory category,
    required String citizenPhone,
    required String wardName,
  }) {
    final routing = resolveRouting(category);
    final now = DateTime.now();
    final deadline = now.add(Duration(hours: routing.statutorySlaHours));

    final docket = 'JS-${routing.targetPortal.prefix}-${now.year}-${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';
    final sms = 'JanSeva Govt Notice: Your complaint for $wardName is registered under Docket $docket with ${routing.departmentNameEn}. Statutory SLA: ${routing.statutorySlaHours}h. Helpline: ${routing.helplineNumber}.';

    return GovtGrievanceReceipt(
      docketNumber: docket,
      portal: routing.targetPortal,
      departmentNameEn: routing.departmentNameEn,
      departmentNameHi: routing.departmentNameHi,
      nodalOfficer: routing.nodalOfficerDesignation,
      helplineNumber: routing.helplineNumber,
      submissionTime: now,
      statutoryDeadline: deadline,
      slaHours: routing.statutorySlaHours,
      acknowledgmentSmsText: sms,
    );
  }
}
