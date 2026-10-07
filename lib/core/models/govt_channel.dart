enum GovtPortalType {
  cpgrams(
    code: 'CPGRAMS',
    nameEn: 'Central CPGRAMS Portal',
    nameHi: 'केंद्रीय सीपीजीआरएएमएस पोर्टल',
    tier: 'Central Government',
    tierHi: 'केंद्र सरकार',
    prefix: 'CPG',
  ),
  stateJanSunwai(
    code: 'JAN_SUNWAI',
    nameEn: 'State CM Jan Sunwai Helpline',
    nameHi: 'मुख्यमंत्री जन सुनवाई हेल्पलाइन',
    tier: 'State Government',
    tierHi: 'राज्य सरकार',
    prefix: 'STA',
  ),
  municipal311(
    code: 'MUNICIPAL_311',
    nameEn: 'Urban Local Body (ULB 311)',
    nameHi: 'नगर निगम 311 सेवा',
    tier: 'Municipal Corporation',
    tierHi: 'नगर निगम',
    prefix: 'ULB',
  ),
  swachhata(
    code: 'SWACHHATA',
    nameEn: 'MoHUA Swachhata Citizen App',
    nameHi: 'स्वच्छता नागरिक ऐप',
    tier: 'National Urban Sanitation',
    tierHi: 'राष्ट्रीय स्वच्छता मिशन',
    prefix: 'SBM',
  ),
  jalBoard(
    code: 'JAL_BOARD',
    nameEn: 'State Jal Board & Sewerage',
    nameHi: 'राज्य जल बोर्ड एवं जल निकासी',
    tier: 'Water Utilities',
    tierHi: 'जल उपयोगिता प्रभाग',
    prefix: 'JAL',
  ),
  discomPower(
    code: 'DISCOM',
    nameEn: 'State Electricity DISCOM',
    nameHi: 'राज्य विद्युत वितरण निगम',
    tier: 'Power Utilities',
    tierHi: 'विद्युत वितरण प्रभाग',
    prefix: 'PWR',
  );

  const GovtPortalType({
    required this.code,
    required this.nameEn,
    required this.nameHi,
    required this.tier,
    required this.tierHi,
    required this.prefix,
  });

  final String code;
  final String nameEn;
  final String nameHi;
  final String tier;
  final String tierHi;
  final String prefix;
}

class GovtDepartmentRouting {
  final String departmentNameEn;
  final String departmentNameHi;
  final GovtPortalType targetPortal;
  final String nodalOfficerDesignation;
  final int statutorySlaHours;
  final String helplineNumber;
  final bool isAutomaticEscalationEnabled;

  const GovtDepartmentRouting({
    required this.departmentNameEn,
    required this.departmentNameHi,
    required this.targetPortal,
    required this.nodalOfficerDesignation,
    required this.statutorySlaHours,
    required this.helplineNumber,
    this.isAutomaticEscalationEnabled = true,
  });
}
