// Real-Life Civic Cases Tranche 3: Essential Public Services, Welfare & Anti-Corruption

// ----------------------------------------------------------------------------
// LOOP 11: Tree Preservation Act & Illegal Felling Vigilance Engine
// ----------------------------------------------------------------------------
class TreeProtectionIncidentReport {
  final String location;
  final String wardName;
  final String treeSpecies;
  final int numberOfTrees;
  final bool isOngoingFellingActivity;
  final bool hasTreeOfficerPermitShown;

  const TreeProtectionIncidentReport({
    required this.location,
    required this.wardName,
    required this.treeSpecies,
    required this.numberOfTrees,
    required this.isOngoingFellingActivity,
    required this.hasTreeOfficerPermitShown,
  });

  String generateTreeOfficerEmergencyPetition() {
    return '''
========================================================================
URGENT PETITION UNDER PRESERVATION OF TREES ACT & FOREST LAWS
========================================================================
To:
The Tree Officer & Deputy Conservator of Forests (DCF),
Forest Department / Municipal Tree Authority, Ward: $wardName

SUBJECT: Emergency Stop-Work Order against Illegal Tree Felling / Heavy Pruning
LOCATION: $location (Ward $wardName)

Respected Tree Officer,
Illegal destruction of green canopy is taking place in direct violation of the Tree Preservation Act:
1. Species: $treeSpecies | Number of Trees Affected: $numberOfTrees
2. Ongoing Felling: ${isOngoingFellingActivity ? 'ACTIVE NOW - IMMEDIATE POLICE RAID NEEDED' : 'Felled Timber on Site'}
3. Statutory Permission / Permit: ${hasTreeOfficerPermitShown ? 'Permit produced' : 'NO VALID PERMIT DISPLAYED'}

STATUTORY PROVISIONS:
Felling of any tree without express written permission of the Tree Officer is a cognizable offence.

PRAYER:
1. Issue an immediate Stop-Work Order and dispatch Forest Guard / Police to seize saws and machinery.
2. Direct confiscation of timber and register FIR under Section 8/24 of the State Preservation of Trees Act.
3. Impose mandatory compensatory plantation of 10 saplings per damaged tree under security deposit forfeiture.

Reported via JanSeva Green Canopy Protection Cell.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 12: NFSA 2013 PDS Ration Siphoning & DGRO Statutory Petition
// ----------------------------------------------------------------------------
class PdsRationDenialReport {
  final String rationCardNumber;
  final String cardholderName;
  final String fairPriceShopNumber; // FPS / Ration dealer ID
  final String monthYear;
  final double entitledWheatKg;
  final double entitledRiceKg;
  final bool isPosMachineBiometricFailure;
  final bool isDealerRefusingRation;

  const PdsRationDenialReport({
    required this.rationCardNumber,
    required this.cardholderName,
    required this.fairPriceShopNumber,
    required this.monthYear,
    required this.entitledWheatKg,
    required this.entitledRiceKg,
    required this.isPosMachineBiometricFailure,
    required this.isDealerRefusingRation,
  });

  String generateDgroPetition() {
    return '''
========================================================================
STATUTORY PETITION BEFORE DISTRICT GRIEVANCE REDRESSAL OFFICER (DGRO)
UNDER SECTION 15 OF THE NATIONAL FOOD SECURITY ACT, 2013 (NFSA)
========================================================================
To:
The District Grievance Redressal Officer (DGRO) / Additional District Magistrate (ADM),
Department of Food, Civil Supplies & Consumer Affairs

IN THE MATTER OF:
Ration Cardholder: $cardholderName | Ration Card No: $rationCardNumber
VERSUS
Fair Price Shop (FPS) Dealer No: $fairPriceShopNumber

SUBJECT: Denial of Subsidized Foodgrains for the Month of $monthYear

Respected Officer,
The Complainant is a verified NFSA beneficiary entitled to subsidized foodgrains:
- Entitlement: $entitledWheatKg Kg Wheat + $entitledRiceKg Kg Rice
- e-PoS Device Biometric Failure: ${isPosMachineBiometricFailure ? 'YES - OTP/Nominee bypass denied by dealer' : 'No'}
- Unlawful Denial by Dealer: ${isDealerRefusingRation ? 'YES - False claim of "Stock Finished"' : 'Partial allocation'}

STATUTORY MANDATE UNDER NFSA 2013:
Section 13 & 15 guarantee uninterrupted access to foodgrains and mandate disposal 
of citizen complaints within 30 days, including grant of Food Security Allowance under Section 8.

PRAYER:
a) Conduct surprise audit of physical stock versus electronic PoS ledger at FPS No. $fairPriceShopNumber.
b) Direct immediate disbursement of foodgrain quota to Complainant.
c) Suspend license of the Fair Price Shop dealer if diversion or black-marketing is detected.

Complainant: $cardholderName via JanSeva Food Security Cell.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 13: National Health Mission (NHM) Essential Drug & Hospital Absence Auditor
// ----------------------------------------------------------------------------
class PublicHospitalAuditRecord {
  final String hospitalName; // PHC / CHC / District Hospital
  final String wardOrDistrict;
  final String missingEssentialDrugName; // E.g., Paracetamol, Insulin, Anti-Snake Venom, ORS
  final bool isDoctorAbsentDuringOpdHours;
  final String opdTimingSlot;

  const PublicHospitalAuditRecord({
    required this.hospitalName,
    required this.wardOrDistrict,
    required this.missingEssentialDrugName,
    required this.isDoctorAbsentDuringOpdHours,
    required this.opdTimingSlot,
  });

  String generateChiefMedicalOfficerPetition() {
    return '''
========================================================================
AUDIT COMPLAINT UNDER NATIONAL HEALTH MISSION & INDIAN PUBLIC HEALTH STANDARDS
========================================================================
To:
The Chief Medical Officer (CMO) / Mission Director, National Health Mission (NHM),
District: $wardOrDistrict

SUBJECT: Essential Medicine Stockout & OPD Doctor Absenteeism at Public Facility
HEALTH CENTER: $hospitalName

Respected CMO,
Citizens visiting $hospitalName faced critical denial of basic healthcare services:
1. OPD Absenteeism: ${isDoctorAbsentDuringOpdHours ? 'DUTY DOCTOR ABSENT DURING OPD HOURS ($opdTimingSlot)' : 'Doctor present'}
2. Essential Drug Stockout: "$missingEssentialDrugName" unavailable at government dispensary.
3. Patients forced to purchase life-saving medicine from external private chemist shops.

INDIAN PUBLIC HEALTH STANDARDS (IPHS) COMPLIANCE:
Under the National Essential Medicines List (NEML) and Free Drug Service Initiative, 
PHCs and CHCs must maintain 100% availability of vital drugs with zero stockout days.

DEMANDS:
a) Restock $missingEssentialDrugName immediately from the District Medical Warehouse.
b) Mark duty doctor absent and initiate disciplinary inquiry into unnotified absence.
c) Audit Jan Aushadhi Kendra medicine inventory at this facility.

Filed for public health welfare via JanSeva Health Sentinel.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 14: RTPS Timely Service Guarantee & ACB 1064 Whistleblowing Dossier
// ----------------------------------------------------------------------------
class ServiceDeliveryDelayAudit {
  final String serviceName; // Birth Certificate, Caste Certificate, Land Mutation
  final String applicationReferenceNumber;
  final String citizenName;
  final int statutoryLimitDays;
  final int actualElapsedDays;
  final bool hasBriberyDemand;
  final double briberyAmountDemanded;

  const ServiceDeliveryDelayAudit({
    required this.serviceName,
    required this.applicationReferenceNumber,
    required this.citizenName,
    required this.statutoryLimitDays,
    required this.actualElapsedDays,
    required this.hasBriberyDemand,
    this.briberyAmountDemanded = 0.0,
  });

  int get daysOverdue => actualElapsedDays > statutoryLimitDays ? actualElapsedDays - statutoryLimitDays : 0;

  double computeStatutoryDelayCompensation() {
    // Under Right to Public Services Acts: ₹250 per day of unnotified delay
    return daysOverdue * 250.0;
  }

  String generateRtpsAndAcbPetition() {
    final comp = computeStatutoryDelayCompensation();
    return '''
========================================================================
PETITION UNDER RIGHT TO PUBLIC SERVICES ACT & ANTI-CORRUPTION BUREAU 1064
========================================================================
To:
1. The First Appellate Authority, Right to Public Services (RTPS) Commission
2. The Superintendent of Police, Anti-Corruption Bureau / Vigilance Directorate (Toll-Free 1064)

APPLICATION REF: $applicationReferenceNumber | SERVICE: $serviceName
APPLICANT: $citizenName

1. STATUTORY BREACH UNDER RIGHT TO GUARANTEED DELIVERY OF SERVICES:
   - Guaranteed Statutory Timeline: $statutoryLimitDays Days
   - Actual Days Elapsed: $actualElapsedDays Days
   - Illegal Overdue Delay: $daysOverdue Days
   - Statutory Compensation Due to Citizen: ₹$comp (Deductible from dealing assistant's salary)

2. CORRUPTION & BRIBERY ALLEGATION:
   ${hasBriberyDemand ? 'ACTIVE BRIBERY DEMAND: ₹$briberyAmountDemanded demanded by counter staff for clearance.' : 'Administrative harassment without justifiable cause.'}

PRAYER:
a) Issue the pending certificate/service within 24 hours without further bureaucratic harassment.
b) Order payment of ₹$comp as statutory compensation to the applicant.
${hasBriberyDemand ? 'c) Register confidential vigilance dossier under Prevention of Corruption Act, 1988.' : ''}

Submitted via JanSeva Public Service & Integrity Cell.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 15: Vector-Borne DBC & Municipal Mosquito-Genic Fogging Requisition
// ----------------------------------------------------------------------------
class VectorControlRequisition {
  final String wardName;
  final String locality;
  final bool hasDengueMalariaCases;
  final int activePatientCount;
  final bool hasStagnantWaterBody;
  final int daysSinceLastFogging;

  const VectorControlRequisition({
    required this.wardName,
    required this.locality,
    required this.hasDengueMalariaCases,
    required this.activePatientCount,
    required this.hasStagnantWaterBody,
    required this.daysSinceLastFogging,
  });

  String generateMalariaOfficerPetition() {
    return '''
========================================================================
EMERGENCY REQUISITION: MOSQUITO VECTOR CONTROL & THERMAL FOGGING
UNDER SECTION 214 OF MUNICIPAL CORPORATION ACT
========================================================================
To:
The District Malaria Officer / Domestic Breeding Checker (DBC) In-Charge,
Municipal Health Department, Ward: $wardName

SUBJECT: Outbreak Prevention Requisition for Anti-Larval Spray & Thermal Fogging
LOCALITY: $locality (Ward $wardName)

Respected Health Officer,
An alarming rise in vector-borne diseases is reported from this pocket:
- Confirmed Dengue / Malaria Cases: ${hasDengueMalariaCases ? 'YES ($activePatientCount Active Patients)' : 'None'}
- Stagnant Water / Construction Trench: ${hasStagnantWaterBody ? 'Severe Breeding Ground' : 'None'}
- Days Since Municipal Fogging: $daysSinceLastFogging Days (Norm: Once every 7 days during monsoon)

STATUTORY HEALTH MEASURES DEMANDED:
1. Deploy DBC inspectors to conduct door-to-door larval inspection and introduce temephos / Gambusia fish.
2. Schedule mounted vehicle thermal fogging with Pyrethrum insecticide at dusk (5:30 PM - 7:00 PM).
3. Issue legal notice to private plot owners with stagnant water under Section 214.

Dispatched via JanSeva Vector-Borne Disease Control Sentinel.
''';
  }
}
