import '../models/grievance.dart';

class RtiApplicationDraft {
  final String applicationNumber;
  final String departmentName;
  final String pioDesignation;
  final String subject;
  final List<String> queries;
  final String fullDraftText;
  final DateTime generatedDate;

  const RtiApplicationDraft({
    required this.applicationNumber,
    required this.departmentName,
    required this.pioDesignation,
    required this.subject,
    required this.queries,
    required this.fullDraftText,
    required this.generatedDate,
  });
}

class RtiPetitionGenerator {
  /// Generates an exact, legally enforceable RTI application under Section 6(1)
  /// of the Right to Information Act, 2005 for overdue civic grievances.
  static RtiApplicationDraft generateDraft({
    required Grievance grievance,
    String? citizenName,
    String? citizenAddress,
    String? citizenPhone,
  }) {
    final now = DateTime.now();
    final docket = grievance.govtDocketNumber ?? grievance.id;
    final dept = grievance.govtDepartmentName ?? 'Municipal Corporation / Works Department';
    final name = citizenName ?? grievance.citizenName;
    final address = citizenAddress ?? grievance.address;
    final phone = citizenPhone ?? grievance.citizenPhone;

    final queries = [
      'Certified copy of the sanctioned Work Order, Tender Agreement, and contractor contract for maintenance at "${grievance.address}" (Ward: ${grievance.wardName}).',
      'Name, official designation, office address, and contact number of the Junior Engineer (JE) and Assistant Engineer (AE) assigned to oversee this area.',
      'Daily site inspection log, measurement book records, and contractor compliance entries since the filing of Complaint Docket $docket on ${grievance.createdAt.toIso8601String().substring(0, 10)}.',
      'Certified reasons recorded in writing for failure to redress the citizen grievance within the statutory Citizens Charter SLA deadline (${grievance.slaDeadline.toIso8601String().substring(0, 10)}).',
      'Details of penalty, liquidated damages, or adverse performance notices levied against the contractor/nodal officer under the service contract agreement.',
    ];

    final fullText = '''
========================================================================
FORM A: APPLICATION FOR OBTAINING INFORMATION UNDER SECTION 6(1)
OF THE RIGHT TO INFORMATION ACT, 2005
========================================================================

To:
The Public Information Officer (PIO) / Assistant PIO
$dept
Municipal Corporation / Division Office
Ward: ${grievance.wardName}

1. FULL NAME OF APPLICANT:
   $name

2. ADDRESS FOR CORRESPONDENCE:
   $address
   Contact: $phone
   Citizenship: Citizen of India

3. SUBJECT MATTER:
   Seeking certified information regarding pending civic works and breach of
   statutory Citizens Charter SLA for Grievance Docket: $docket

4. PARTICULARS OF INFORMATION SOUGHT (UNDER SECTION 2(f) & 2(j)):
${queries.asMap().entries.map((e) => '   (${e.key + 1}) ${e.value}').join('\n\n')}

5. STATUTORY PERIOD & FEES:
   - Statutory fee of Rs. 10/- payable via Indian Postal Order (IPO) / Court Fee Stamp / Online Portal.
   - Kindly provide the requested information within 30 days as mandated under Section 7(1) of the RTI Act, 2005.
   - If this application pertains to another public authority, kindly transfer it within 5 days under Section 6(3).

Place: ${grievance.wardName}
Date: ${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}

Applicant Signature: _______________________
($name)
========================================================================
''';

    return RtiApplicationDraft(
      applicationNumber: 'RTI-$docket-${now.millisecondsSinceEpoch.toString().substring(7)}',
      departmentName: dept,
      pioDesignation: 'Public Information Officer (PIO), $dept',
      subject: 'RTI Application under Section 6(1) for Grievance Docket: $docket',
      queries: queries,
      fullDraftText: fullText,
      generatedDate: now,
    );
  }
}
