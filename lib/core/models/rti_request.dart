class RtiRequest {
  final String id;
  final String applicantName;
  final String department;
  final String subject;
  final String queryDetails;
  final bool bplFeeExempt;
  final String status;
  final DateTime filedDate;
  final DateTime statutoryDeadline;
  final String pioOfficerName;
  final String? responseSummary;

  const RtiRequest({
    required this.id,
    required this.applicantName,
    required this.department,
    required this.subject,
    required this.queryDetails,
    this.bplFeeExempt = false,
    required this.status,
    required this.filedDate,
    required this.statutoryDeadline,
    required this.pioOfficerName,
    this.responseSummary,
  });

  int get daysRemaining => statutoryDeadline.difference(DateTime.now()).inDays;
  bool get isOverdue => DateTime.now().isAfter(statutoryDeadline);

  static List<RtiRequest> get sampleRequests => [
        RtiRequest(
          id: 'RTI/MCD/2026/0114',
          applicantName: 'Rahul Sharma',
          department: 'Public Works Department (PWD)',
          subject: 'Expenditure & Contractor Details for Ward 1 Culvert Repair',
          queryDetails:
              'Certified copy of work orders, measurement book records, and contractor completion certificate for Culvert project PW-2026-081.',
          status: 'Under Review by PIO',
          filedDate: DateTime.now().subtract(const Duration(days: 8)),
          statutoryDeadline: DateTime.now().add(const Duration(days: 22)),
          pioOfficerName: 'Er. S. K. Rastogi (Public Information Officer)',
        ),
        RtiRequest(
          id: 'RTI/MCD/2026/0089',
          applicantName: 'Rahul Sharma',
          department: 'Health & Sanitation',
          subject: 'Sanitation Staff Roster & Biometric Attendance - Ward 2',
          queryDetails:
              'Daily sanitation muster rolls and fogging log sheets for Ward 2 Gandhi Nagar for January 2026.',
          status: 'Information Dispatched',
          filedDate: DateTime.now().subtract(const Duration(days: 25)),
          statutoryDeadline: DateTime.now().add(const Duration(days: 5)),
          pioOfficerName: 'Dr. Meenakshi Joshi (Dy. Health Officer)',
          responseSummary: 'Certified copies dispatched via Registered Post (SpeedPost Tracking: ED98102341IN).',
        ),
      ];
}
