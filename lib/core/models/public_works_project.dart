class PublicWorksProject {
  final String id;
  final String title;
  final String wardName;
  final String category;
  final String contractorName;
  final String tenderReference;
  final double allocatedBudgetLakhs;
  final double spentBudgetLakhs;
  final int progressPercent;
  final String status;
  final double citizenAuditScore;
  final int auditReviewsCount;
  final DateTime startDate;
  final DateTime targetDate;
  final String recentMilestone;

  const PublicWorksProject({
    required this.id,
    required this.title,
    required this.wardName,
    required this.category,
    required this.contractorName,
    required this.tenderReference,
    required this.allocatedBudgetLakhs,
    required this.spentBudgetLakhs,
    required this.progressPercent,
    required this.status,
    required this.citizenAuditScore,
    required this.auditReviewsCount,
    required this.startDate,
    required this.targetDate,
    required this.recentMilestone,
  });

  PublicWorksProject copyWith({
    String? id,
    String? title,
    String? wardName,
    String? category,
    String? contractorName,
    String? tenderReference,
    double? allocatedBudgetLakhs,
    double? spentBudgetLakhs,
    int? progressPercent,
    String? status,
    double? citizenAuditScore,
    int? auditReviewsCount,
    DateTime? startDate,
    DateTime? targetDate,
    String? recentMilestone,
  }) {
    return PublicWorksProject(
      id: id ?? this.id,
      title: title ?? this.title,
      wardName: wardName ?? this.wardName,
      category: category ?? this.category,
      contractorName: contractorName ?? this.contractorName,
      tenderReference: tenderReference ?? this.tenderReference,
      allocatedBudgetLakhs: allocatedBudgetLakhs ?? this.allocatedBudgetLakhs,
      spentBudgetLakhs: spentBudgetLakhs ?? this.spentBudgetLakhs,
      progressPercent: progressPercent ?? this.progressPercent,
      status: status ?? this.status,
      citizenAuditScore: citizenAuditScore ?? this.citizenAuditScore,
      auditReviewsCount: auditReviewsCount ?? this.auditReviewsCount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      recentMilestone: recentMilestone ?? this.recentMilestone,
    );
  }

  static List<PublicWorksProject> get sampleProjects => [
        PublicWorksProject(
          id: 'PW-2026-081',
          title: 'Stormwater Culvert Deepening & Flood Abatement',
          wardName: 'Ward 1 - Civil Lines',
          category: 'Drainage Network',
          contractorName: 'Apex InfraCorp Ltd.',
          tenderReference: 'MCD/TND/2026/042-DRN',
          allocatedBudgetLakhs: 48.5,
          spentBudgetLakhs: 34.2,
          progressPercent: 72,
          status: 'In Progress',
          citizenAuditScore: 4.4,
          auditReviewsCount: 38,
          startDate: DateTime(2026, 1, 15),
          targetDate: DateTime(2026, 5, 30),
          recentMilestone: 'Precast RCC Box culverts installed along Main Canal sector 3.',
        ),
        PublicWorksProject(
          id: 'PW-2026-044',
          title: 'Smart LED Grid & Sensorised Solar Illumination',
          wardName: 'Ward 2 - Gandhi Nagar',
          category: 'Street Lighting',
          contractorName: 'UrjaTech Civic Systems',
          tenderReference: 'MCD/TND/2026/019-ELE',
          allocatedBudgetLakhs: 22.0,
          spentBudgetLakhs: 21.6,
          progressPercent: 100,
          status: 'Completed',
          citizenAuditScore: 4.8,
          auditReviewsCount: 92,
          startDate: DateTime(2025, 11, 1),
          targetDate: DateTime(2026, 2, 28),
          recentMilestone: 'Commissioned 420 smart LED poles with automated dusk-to-dawn sensors.',
        ),
        PublicWorksProject(
          id: 'PW-2026-092',
          title: 'Bituminous Heavy Pavement & Flyover Underside Resurfacing',
          wardName: 'Ward 3 - Industrial Area',
          category: 'Roads & Bridges',
          contractorName: 'National Highway Civics JV',
          tenderReference: 'MCD/TND/2026/067-ROD',
          allocatedBudgetLakhs: 115.0,
          spentBudgetLakhs: 62.0,
          progressPercent: 54,
          status: 'In Progress',
          citizenAuditScore: 3.6,
          auditReviewsCount: 24,
          startDate: DateTime(2026, 2, 10),
          targetDate: DateTime(2026, 6, 15),
          recentMilestone: 'Sub-base compaction and mastic asphalt laying phase 1 done.',
        ),
        PublicWorksProject(
          id: 'PW-2026-031',
          title: 'Community Eco-Park & Rainwater Percolation Wells',
          wardName: 'Ward 4 - Model Town',
          category: 'Parks & Greenery',
          contractorName: 'GreenScape Urban Solutions',
          tenderReference: 'MCD/TND/2025/112-ENV',
          allocatedBudgetLakhs: 35.0,
          spentBudgetLakhs: 28.5,
          progressPercent: 88,
          status: 'Under Audit',
          citizenAuditScore: 4.6,
          auditReviewsCount: 56,
          startDate: DateTime(2025, 12, 5),
          targetDate: DateTime(2026, 3, 31),
          recentMilestone: 'Recharge wells completed; third-party municipal soil audit underway.',
        ),
      ];
}
