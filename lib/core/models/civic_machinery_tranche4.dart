// Real-Life Civic Cases Tranche 4: Environmental Quality, Urban Planning & High Escalation

// ----------------------------------------------------------------------------
// LOOP 16: CAQM & GRAP Dust / Construction Pollution Enforcement Engine
// ----------------------------------------------------------------------------
class ConstructionDustPollutionReport {
  final String siteAddress;
  final String builderOrContractorName;
  final bool hasGreenSheetCovering;
  final bool hasAntiSmogGunOperating;
  final bool isUncoveredSandGravelStored;
  final String currentAqiZone;

  const ConstructionDustPollutionReport({
    required this.siteAddress,
    required this.builderOrContractorName,
    required this.hasGreenSheetCovering,
    required this.hasAntiSmogGunOperating,
    required this.isUncoveredSandGravelStored,
    required this.currentAqiZone,
  });

  String generateCaqmPollutionPetition() {
    return '''
========================================================================
STATUTORY NOTICE UNDER COMMISSION FOR AIR QUALITY MANAGEMENT (CAQM) ACT
& GRADED RESPONSE ACTION PLAN (GRAP) DIRECTIVES
========================================================================
To:
1. The Member Secretary, Commission for Air Quality Management (CAQM)
2. The Chief Environmental Engineer, State Pollution Control Board Dust Portal

SUBJECT: Gross Violation of Dust Mitigation Norms at Construction Site
SITE: $siteAddress | CONTRACTOR: $builderOrContractorName

Respected Environmental Authorities,
During active GRAP enforcement (Current AQI Category: $currentAqiZone), 
the subject construction site is operating in blatant disregard of statutory dust norms:
- Green Net / Tarpaulin Perimeter Shield: ${hasGreenSheetCovering ? 'Installed' : 'MISSING (DUST BLOWING ON ROAD)'}
- Anti-Smog Gun / Water Sprinklers: ${hasAntiSmogGunOperating ? 'Operating' : 'DEFUNCT / NOT DEPLOYED'}
- Uncovered C&D Debris / Sand: ${isUncoveredSandGravelStored ? 'YES - LOOSE SILICA PARTICLES IN AIR' : 'Covered'}

STATUTORY ENVIRONMENTAL ACTION DEMANDED:
1. Immediate issuance of Stop-Work Notice under Section 12 of the CAQM Act 2021.
2. Levy of Environmental Damage Compensation (EDC) of ₹5,00,000 on the project proponent.
3. Sealing of entry gate until 14-point C&D dust management guidelines are verified on camera.

Reported by Conscious Citizen via JanSeva Clean Air Sentinel.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 17: Horticulture & Public Park Rejuvenation Resolution Engine
// ----------------------------------------------------------------------------
class PublicParkConditionAudit {
  final String parkName;
  final String wardName;
  final int brokenChildrenSwingsCount;
  final bool hasOvergrownWildVegetation;
  final bool hasDeadHazardousBranches;
  final bool isLightingWorkingInPark;

  const PublicParkConditionAudit({
    required this.parkName,
    required this.wardName,
    required this.brokenChildrenSwingsCount,
    required this.hasOvergrownWildVegetation,
    required this.hasDeadHazardousBranches,
    required this.isLightingWorkingInPark,
  });

  String generateHorticultureDirectorPetition() {
    return '''
========================================================================
PUBLIC PARK REJUVENATION & SAFETY REQUISITION - MUNICIPAL HORTICULTURE
========================================================================
To:
The Director / Deputy Director (Horticulture), Municipal Corporation,
Ward: $wardName

SUBJECT: Rehabilitation of Children Play Area & Public Green in $parkName

Respected Director,
A comprehensive audit of $parkName in Ward $wardName reveals hazardous conditions:
1. Children Safety: $brokenChildrenSwingsCount broken metal swings/slides presenting laceration hazard.
2. Arboreal Safety: ${hasDeadHazardousBranches ? 'DEAD BRANCHES AT RISK OF COLLAPSE ON WALKERS' : 'Safe trees'}
3. Security: ${isLightingWorkingInPark ? 'Adequate lighting' : 'DEFUNCT LIGHTS CREATING ANTI-SOCIAL HUB'}
4. Maintenance: ${hasOvergrownWildVegetation ? 'Overgrown bushes breeding reptiles and pests' : 'Manicured'}

PRAYER:
a) Deploy horticulture maintenance squad with grass mowers and tree trimmers within 48 hours.
b) Repair or replace damaged play swings under the Urban Child Welfare Fund.
c) Conduct joint inspection with the local Resident Welfare Association (RWA).

Submitted via JanSeva Urban Green Spaces Network.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 18: Cross-Contamination Water-Sewer Siphonage Emergency Response
// ----------------------------------------------------------------------------
class WaterSewerCrossContaminationAlert {
  final String locality;
  final String wardName;
  final int affectedHouseholdsCount;
  final bool hasGastroenteritisCases;
  final String estimatedLeakPoint;

  const WaterSewerCrossContaminationAlert({
    required this.locality,
    required this.wardName,
    required this.affectedHouseholdsCount,
    required this.hasGastroenteritisCases,
    required this.estimatedLeakPoint,
  });

  String generateEmergencySiphonageProtocolNotice() {
    return '''
========================================================================
CRITICAL BIO-HAZARD ALERT: CROSS-CONTAMINATION & SEWER-WATER SIPHONAGE
========================================================================
To:
1. The Chief Engineer (Water Supply & Drainage Operations), Jal Board
2. The District Magistrate (DM) / Chairman, District Disaster Management Authority (DDMA)
Locality: $locality (Ward $wardName)

SUBJECT: EMERGENCY CODE RED: Sewage water entering drinking water distribution main
ESTIMATED BREACH LOCATION: $estimatedLeakPoint | AFFECTED HOMES: ~$affectedHouseholdsCount

CRITICAL MEDICAL EMERGENCY:
Black, foul-smelling effluent is flowing from residential drinking water taps.
- Acute Diarrhea / Gastroenteritis Reported: ${hasGastroenteritisCases ? 'ACTIVE SICKNESS IN LOCALITY' : 'No symptoms yet'}

DISASTER MANAGEMENT ACT EMERGENCY PROTOCOL ACTIVATION:
1. IMMEDIATE VALVE SHUTOFF: Isolate the contaminated distribution pipeline immediately.
2. POTABLE WATER TANKERS: Mobilize minimum 4 drinking water tankers to $locality within 90 minutes.
3. ACOUSTIC LEAK DETECTION: Deploy pressurized tracer team to excavate and repair the breached sewer junction.
4. HEALTH EPIDEMIC CAMP: Direct CMO to set up an emergency medical outpost with ORS and antibiotics.

Dispatched via JanSeva Emergency Public Health Sentinel.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 19: UBBL Building Bye-Laws & Section 343 Unauthorized Construction
// ----------------------------------------------------------------------------
class BuildingViolationReport {
  final String propertyAddress;
  final String wardName;
  final int sanctionedFloors;
  final int actualConstructedFloors;
  final bool isEncroachingPublicSetback;
  final bool hasOngoingConstructionAtNight;

  const BuildingViolationReport({
    required this.propertyAddress,
    required this.wardName,
    required this.sanctionedFloors,
    required this.actualConstructedFloors,
    required this.isEncroachingPublicSetback,
    required this.hasOngoingConstructionAtNight,
  });

  int get unauthorizedFloors => actualConstructedFloors > sanctionedFloors ? actualConstructedFloors - sanctionedFloors : 0;

  String generateSection343ShowCausePetition() {
    return '''
========================================================================
STATUTORY REPORT UNDER SECTION 343 & 344 OF MUNICIPAL CORPORATION ACT
UNIFIED BUILDING BYE-LAWS (UBBL) NON-COMPLIANCE
========================================================================
To:
The Superintending Engineer (Building) / Zonal Deputy Commissioner,
Municipal Corporation Building Department, Ward: $wardName

SUBJECT: Commercial Unauthorized Multi-Storey Construction & Setback Encroachment
PROPERTY: $propertyAddress

Respected Authority,
This is a formal report regarding illegal construction in violation of the Master Plan:
1. Sanctioned Height / Floors: Ground + $sanctionedFloors Floors
2. Actual Illegal Construction: Ground + $actualConstructedFloors Floors (Excess: +$unauthorizedFloors Unauthorized Floors)
3. Mandatory Front/Side Setback: ${isEncroachingPublicSetback ? '100% ENCROACHED ONTO COMMON LANE' : 'Compliant'}
4. NGT Night Construction Violation: ${hasOngoingConstructionAtNight ? 'Violating 10 PM - 6 AM curfew' : 'No'}

STATUTORY MANDATE:
Under Section 343/344, the Zonal Authority is legally bound to:
a) Issue immediate Stop-Work Order and order disconnection of water and electricity connections.
b) Issue Demolition Notice under Section 343(1) and seal unauthorized upper floors under Section 345-A.
c) Inquire into complicity of the local Junior Engineer (Building) for failure to notice 5-story deviation.

Submitted via JanSeva Urban Planning & Transparency Cell.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 20: Statutory First Appeal (RTI Sec 19) & State Lokayukta Corruption Redressal
// ----------------------------------------------------------------------------
class StatutoryAppellateDossier {
  final String originalRtiApplicationNumber;
  final String departmentName;
  final String citizenName;
  final DateTime rtiFilingDate;
  final bool isPioCompletelySilentAfter30Days;
  final String substantiveCivicGrievanceSummary;

  const StatutoryAppellateDossier({
    required this.originalRtiApplicationNumber,
    required this.departmentName,
    required this.citizenName,
    required this.rtiFilingDate,
    required this.isPioCompletelySilentAfter30Days,
    required this.substantiveCivicGrievanceSummary,
  });

  int get elapsedDaysSinceRti => DateTime.now().difference(rtiFilingDate).inDays;

  String generateFirstAppealPetition() {
    return '''
========================================================================
MEMORANDUM OF FIRST APPEAL UNDER SECTION 19(1) OF THE RTI ACT, 2005
========================================================================
Before: The First Appellate Authority (FAA) / Additional Commissioner,
Department: $departmentName

IN THE MATTER OF:
$citizenName (Appellant)
VERSUS
The Public Information Officer (PIO), $departmentName (Respondent)

SUBJECT: First Appeal against deemed refusal and complete silence of the PIO
ORIGINAL RTI APPLICATION NO: $originalRtiApplicationNumber | DATED: ${rtiFilingDate.toIso8601String().substring(0, 10)}

1. BRIEF FACTS OF THE CASE:
   The Appellant submitted a statutory Section 6(1) RTI application on ${rtiFilingDate.toIso8601String().substring(0, 10)} 
   seeking certified records regarding unresolved public grievance: "$substantiveCivicGrievanceSummary".
   - Statutory Period: 30 days expired on ${rtiFilingDate.add(const Duration(days: 30)).toIso8601String().substring(0, 10)}.
   - Total Days Elapsed: $elapsedDaysSinceRti Days.
   - Response from PIO: ${isPioCompletelySilentAfter30Days ? 'NIL (Deemed Refusal under Section 7(2))' : 'Incomplete/Misleading'}

2. GROUNDS OF APPEAL:
   The PIO has violated Section 7(1) of the RTI Act. Under Section 7(6), where information is not supplied 
   within statutory timelines, it must be provided completely FREE OF CHARGE.

PRAYER:
a) Direct the PIO to furnish certified, indexed copies of all requested queries within 10 days free of cost.
b) Recommend penal inquiry under Section 20(1) against the PIO (₹250/day up to ₹25,000).
c) Forward findings to the Hon'ble Lokayukta for systemic dereliction of duty.

Appellant: $citizenName via JanSeva Apex Transparency Gateway.
''';
  }
}
