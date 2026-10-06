enum GrievanceCategory {
  roadsAndPotholes(
    code: 'ROADS',
    displayNameEn: 'Roads & Potholes',
    displayNameHi: 'सड़क एवं गड्ढे',
    slaHours: 48,
    iconName: 'traffic',
  ),
  sanitationAndGarbage(
    code: 'SANITATION',
    displayNameEn: 'Garbage & Sanitation',
    displayNameHi: 'कचरा एवं स्वच्छता',
    slaHours: 24,
    iconName: 'delete_outline',
  ),
  waterSupply(
    code: 'WATER',
    displayNameEn: 'Water Supply & Leakage',
    displayNameHi: 'जल आपूर्ति एवं रिसाव',
    slaHours: 24,
    iconName: 'water_drop_outlined',
  ),
  electricityAndStreetlights(
    code: 'ELECTRICITY',
    displayNameEn: 'Electricity & Streetlights',
    displayNameHi: 'बिजली एवं स्ट्रीट लाइट',
    slaHours: 36,
    iconName: 'lightbulb_outline',
  ),
  sewageAndDrainage(
    code: 'DRAINAGE',
    displayNameEn: 'Sewage & Drainage Overflow',
    displayNameHi: 'सीवेज एवं नाली ओवरफ्लो',
    slaHours: 24,
    iconName: 'waves',
  ),
  publicSafetyAndHazards(
    code: 'SAFETY',
    displayNameEn: 'Public Safety & Hazards',
    displayNameHi: 'जन सुरक्षा एवं खतरे',
    slaHours: 12,
    iconName: 'warning_amber_rounded',
  ),
  strayAnimals(
    code: 'ANIMALS',
    displayNameEn: 'Stray Animals & Control',
    displayNameHi: 'आवारा पशु नियंत्रण',
    slaHours: 72,
    iconName: 'pets',
  ),
  illegalEncroachment(
    code: 'ENCROACHMENT',
    displayNameEn: 'Illegal Encroachment',
    displayNameHi: 'अवैध अतिक्रमण',
    slaHours: 96,
    iconName: 'domain_disabled',
  );

  const GrievanceCategory({
    required this.code,
    required this.displayNameEn,
    required this.displayNameHi,
    required this.slaHours,
    required this.iconName,
  });

  final String code;
  final String displayNameEn;
  final String displayNameHi;
  final int slaHours;
  final String iconName;

  static GrievanceCategory fromCode(String? code) {
    if (code == null) return GrievanceCategory.roadsAndPotholes;
    for (final cat in GrievanceCategory.values) {
      if (cat.code.toUpperCase() == code.toUpperCase() ||
          cat.name.toUpperCase() == code.toUpperCase()) {
        return cat;
      }
    }
    return GrievanceCategory.roadsAndPotholes;
  }
}

enum GrievanceStatus {
  submitted(
    code: 'SUBMITTED',
    labelEn: 'Submitted',
    labelHi: 'दर्ज किया गया',
    stepIndex: 0,
  ),
  triaged(
    code: 'TRIAGED',
    labelEn: 'Under Review',
    labelHi: 'समीक्षाधीन',
    stepIndex: 1,
  ),
  inProgress(
    code: 'IN_PROGRESS',
    labelEn: 'In Progress',
    labelHi: 'कार्य प्रगति पर है',
    stepIndex: 2,
  ),
  resolved(
    code: 'RESOLVED',
    labelEn: 'Resolved',
    labelHi: 'निस्तारित',
    stepIndex: 3,
  ),
  verifiedClosed(
    code: 'VERIFIED_CLOSED',
    labelEn: 'Citizen Verified',
    labelHi: 'नागरिक द्वारा सत्यापित',
    stepIndex: 4,
  ),
  reopened(
    code: 'REOPENED',
    labelEn: 'Reopened',
    labelHi: 'पुनः खोला गया',
    stepIndex: 2,
  );

  const GrievanceStatus({
    required this.code,
    required this.labelEn,
    required this.labelHi,
    required this.stepIndex,
  });

  final String code;
  final String labelEn;
  final String labelHi;
  final int stepIndex;

  bool get isTerminal => this == GrievanceStatus.verifiedClosed;
  bool get isActive => this != GrievanceStatus.verifiedClosed;
  bool get canBeRated => this == GrievanceStatus.resolved;

  static GrievanceStatus fromCode(String? code) {
    if (code == null) return GrievanceStatus.submitted;
    for (final status in GrievanceStatus.values) {
      if (status.code.toUpperCase() == code.toUpperCase() ||
          status.name.toUpperCase() == code.toUpperCase()) {
        return status;
      }
    }
    return GrievanceStatus.submitted;
  }
}

enum GrievancePriority {
  low(weight: 1, label: 'Low', slaMultiplier: 1.5),
  medium(weight: 2, label: 'Medium', slaMultiplier: 1.0),
  high(weight: 3, label: 'High', slaMultiplier: 0.6),
  emergency(weight: 4, label: 'Emergency', slaMultiplier: 0.25);

  const GrievancePriority({
    required this.weight,
    required this.label,
    required this.slaMultiplier,
  });

  final int weight;
  final String label;
  final double slaMultiplier;

  static GrievancePriority fromString(String? val) {
    if (val == null) return GrievancePriority.medium;
    for (final p in GrievancePriority.values) {
      if (p.name.toUpperCase() == val.toUpperCase()) return p;
    }
    return GrievancePriority.medium;
  }
}

enum UserRole {
  citizen(code: 'CITIZEN', label: 'Citizen'),
  wardOfficer(code: 'WARD_OFFICER', label: 'Ward Officer'),
  departmentAdmin(code: 'DEPT_ADMIN', label: 'Department Admin'),
  superAdmin(code: 'SUPER_ADMIN', label: 'Super Admin');

  const UserRole({required this.code, required this.label});
  final String code;
  final String label;

  static UserRole fromCode(String? code) {
    if (code == null) return UserRole.citizen;
    for (final role in UserRole.values) {
      if (role.code.toUpperCase() == code.toUpperCase() ||
          role.name.toUpperCase() == code.toUpperCase()) {
        return role;
      }
    }
    return UserRole.citizen;
  }
}
