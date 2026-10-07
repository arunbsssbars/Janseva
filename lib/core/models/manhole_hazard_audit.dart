/// Open Manhole & Sewer Hazard Enforcement under Section 133 CrPC / Sec 152 BNSS & Supreme Court Guidelines
class ManholeHazardReport {
  final String locationAddress;
  final String wardName;
  final String nearestLandmark;
  final bool isCompletelyOpen;
  final bool hasBrokenCastIronCover;
  final bool isNearSchoolOrHospital;
  final bool isSubmergedUnderMonsoonWater;
  final int daysReportedUnrepaired;

  const ManholeHazardReport({
    required this.locationAddress,
    required this.wardName,
    required this.nearestLandmark,
    required this.isCompletelyOpen,
    required this.hasBrokenCastIronCover,
    required this.isNearSchoolOrHospital,
    required this.isSubmergedUnderMonsoonWater,
    required this.daysReportedUnrepaired,
  });

  bool get isImminentFatalityRisk =>
      isCompletelyOpen || isSubmergedUnderMonsoonWater || isNearSchoolOrHospital;

  /// Generates urgent emergency petition to Sub-Divisional Magistrate (SDM)
  String generateSdmSection133Petition({required String docketId}) {
    return '''
========================================================================
URGENT MAGISTERIAL COMPLAINT UNDER SECTION 133 CrPC / SECTION 152 BNSS
========================================================================
To:
The Sub-Divisional Magistrate (SDM) / Executive Magistrate,
Revenue Sub-Division: $wardName

IN RE: Imminent Risk to Human Life from Uncovered Public Sewer Manhole
LOCATION: $locationAddress (Near $nearestLandmark) | DOCKET: $docketId

Respected Magistrate,
I invoke the summary powers vested in you under Section 133 of the Code of Criminal Procedure, 1973
(Section 152 of Bharatiya Nagarik Suraksha Sanhita, 2023) regarding an imminent death trap:

1. HAZARD SPECIFICATION:
   - Completely Uncovered Manhole: ${isCompletelyOpen ? 'YES - FATAL FALL HAZARD' : 'Broken Cover'}
   - Submerged in Flood/Rain Water: ${isSubmergedUnderMonsoonWater ? 'YES - INVISIBLE TRAP FOR PEDESTRIANS' : 'Visible'}
   - Vulnerable Population Vicinity: ${isNearSchoolOrHospital ? 'Near School / Hospital Zone' : 'Standard'}
   - Days Lying Open Without Municipal Action: $daysReportedUnrepaired Days

2. SUPREME COURT OF INDIA MANDATES:
   The Hon'ble Supreme Court in Municipal Council, Ratlam v. Vardichand (AIR 1980 SC 1622) 
   held that municipal corporations cannot take refuge in financial or administrative constraints 
   when human lives are jeopardized by open sewers.

PRAYER BEFORE THE HON'BLE MAGISTRATE:
1. Pass an immediate Conditional Order directing the Executive Engineer, Jal Board / Sewerage Division 
   to install a heavy-duty SFRC (Steel Fiber Reinforced Concrete) cover within 12 hours.
2. Direct the local Police Station to erect reflective danger barricades and blinking caution signage immediately.
3. Initiate inquiry into criminal negligence under Section 287/106 BNS against responsible division officers.

Submitted with urgency on behalf of the residents of $wardName via JanSeva.
''';
  }
}
