/// Defect Liability Period (DLP) status for public roads under PWD / Municipal Corporation
enum DlpStatus {
  withinDlp(labelEn: 'Under Contractor DLP (Free Repair)', labelHi: 'ठेकेदार की गारंटी अवधि (निःशुल्क मरम्मत)'),
  expiredDlp(labelEn: 'DLP Expired (Municipal Maintenance)', labelHi: 'गारंटी समाप्त (नगर निगम अनुरक्षण)'),
  emergencyBreach(labelEn: 'Defaulted Contractor (Penalty Levied)', labelHi: 'ठेकेदार डिफ़ॉल्ट (जुर्माना देय)');

  final String labelEn;
  final String labelHi;
  const DlpStatus({required this.labelEn, required this.labelHi});
}

class PwdRoadContractor {
  final String contractorId;
  final String companyName;
  final String workOrderNumber;
  final DateTime? completionDate;
  final DateTime? dlpExpiryDate;
  final double contractValueInLakhs;
  final double penaltyPerDay;

  const PwdRoadContractor({
    required this.contractorId,
    required this.companyName,
    required this.workOrderNumber,
    this.completionDate,
    this.dlpExpiryDate,
    required this.contractValueInLakhs,
    required this.penaltyPerDay,
  });

  bool get isUnderDlp => dlpExpiryDate != null && DateTime.now().isBefore(dlpExpiryDate!);
}

class PwdRoadDefectAudit {
  final String roadName;
  final String wardName;
  final double lengthInMeters;
  final int potholeCount;
  final bool hasWaterLogging;
  final PwdRoadContractor contractor;
  final DlpStatus dlpStatus;

  const PwdRoadDefectAudit({
    required this.roadName,
    required this.wardName,
    required this.lengthInMeters,
    required this.potholeCount,
    required this.hasWaterLogging,
    required this.contractor,
    required this.dlpStatus,
  });

  /// Computes the statutory penalty payable by the contractor under CPWD Works Manual Clause 14
  double computeContractorPenalty({required int daysDelayed}) {
    if (daysDelayed <= 0) return 0.0;
    return daysDelayed * contractor.penaltyPerDay;
  }

  /// Drafts a formal Notice of Defect to the Executive Engineer (EE), PWD
  String generateExecutiveEngineerNotice({
    required String grievanceDocket,
    required int daysDelayed,
  }) {
    final penalty = computeContractorPenalty(daysDelayed: daysDelayed);
    return '''
========================================================================
FORM: NOTICE OF STATUTORY DEFECT & PENALTY REQUISITION UNDER CPWD MANUAL
========================================================================
To:
The Executive Engineer (Roads Division),
Public Works Department (PWD) / Municipal Corporation,
Ward: $wardName

SUBJECT: Non-rectification of hazardous road surface during Defect Liability Period (DLP)
REFERENCE: Complaint Docket: $grievanceDocket | Work Order: ${contractor.workOrderNumber}

Respected Sir/Madam,
This is to formally bring on record that the road stretch "$roadName" in Ward "$wardName" 
has developed critical structural defects including $potholeCount prominent potholes 
and active waterlogging hazards within the Defect Liability Period (DLP expiring on ${contractor.dlpExpiryDate?.toIso8601String().substring(0, 10) ?? 'Active Warranty Period'}).

1. CONTRACTOR ATTRIBUTION:
   - Firm: ${contractor.companyName} (ID: ${contractor.contractorId})
   - Work Order: ${contractor.workOrderNumber} (Value: ₹${contractor.contractValueInLakhs} Lakhs)

2. STATUTORY PENALTY CLAUSE:
   Under Clause 14/17 of the Standard Contract Agreement and CPWD Works Manual, the contractor 
   is obligated to repair defects within 48 hours of notification.
   - Overdue Days: $daysDelayed days
   - Daily Penalty Rate: ₹${contractor.penaltyPerDay}/day
   - Accumulated Statutory Penalty: ₹$penalty

It is requested that:
a) Immediate site inspection be carried out by the Assistant Engineer.
b) Bitumen hot-mix cold patching be executed immediately at the contractor's risk and cost.
c) ₹$penalty be deducted from the contractor's Performance Guarantee / Security Deposit.

Submitted by Conscious Citizen via JanSeva Civic Network.
''';
  }
}
