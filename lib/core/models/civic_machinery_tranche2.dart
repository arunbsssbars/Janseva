// Real-Life Civic Cases Tranche 2: Urban Safety, Living Standards & Civic Rights

// ----------------------------------------------------------------------------
// LOOP 6: Animal Birth Control (ABC Rules 2023) & Anti-Rabies Tracking
// ----------------------------------------------------------------------------
class AnimalControlIncidentReport {
  final String wardName;
  final String streetAddress;
  final int packSize;
  final bool hasAggressiveBiteIncident;
  final bool areDogsEarNotched; // Ear-notch signifies sterilized & rabies vaccinated
  final String nearestGovtHospitalWithArv; // Anti-Rabies Vaccine availability

  const AnimalControlIncidentReport({
    required this.wardName,
    required this.streetAddress,
    required this.packSize,
    required this.hasAggressiveBiteIncident,
    required this.areDogsEarNotched,
    required this.nearestGovtHospitalWithArv,
  });

  String generateAbcCellRequisition() {
    return '''
========================================================================
REQUISITION UNDER ANIMAL BIRTH CONTROL (ABC) RULES, 2023 & PCA ACT 1960
========================================================================
To:
The Nodal Officer / Veterinary Officer, Animal Birth Control (ABC) Monitoring Cell,
Municipal Corporation / Animal Husbandry Department, Ward: $wardName

SUBJECT: Urgent humane capture, sterilization & anti-rabies vaccination of unsterilized pack
LOCATION: $streetAddress, Ward $wardName

Respected Veterinary Officer,
Under the statutory provisions of the Animal Birth Control Rules, 2023:
1. Pack Size: $packSize canines
2. Ear-Notched (Sterilized): ${areDogsEarNotched ? 'Yes' : 'NO - UNVACCINATED POPULATION'}
3. Aggressive / Bite Incident Reported: ${hasAggressiveBiteIncident ? 'CRITICAL - IMMEDIATE CAGE DEPLOYMENT REQUIRED' : 'Routine'}
4. Anti-Rabies Vaccine (ARV) Verification: Checked at $nearestGovtHospitalWithArv

STATUTORY DIRECTIVES:
- Mobilize the municipal humane-catching ambulance equipped with net catchers.
- Transport dogs to the recognized ABC facility for surgical sterilization and anti-rabies booster.
- Post-surgery convalescence of 4 days, followed by mandatory release back to the exact same territory.

Filed via JanSeva ABC & Public Health Sentinel.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 7: Property Tax Over-Assessment & Section 138 Municipal Appeal
// ----------------------------------------------------------------------------
class PropertyTaxAssessmentAppeal {
  final String propertyUpicNumber;
  final String ownerName;
  final String colonyCategory; // Unit Area System category A, B, C, D, etc.
  final double coveredAreaSqMtr;
  final double municipalDemandedTax;
  final double correctCalculatedTax;

  const PropertyTaxAssessmentAppeal({
    required this.propertyUpicNumber,
    required this.ownerName,
    required this.colonyCategory,
    required this.coveredAreaSqMtr,
    required this.municipalDemandedTax,
    required this.correctCalculatedTax,
  });

  double get disputedAmount => municipalDemandedTax - correctCalculatedTax;

  String generateSection138AppealPetition({required String assessmentYear}) {
    return '''
========================================================================
MEMORANDUM OF APPEAL UNDER SECTION 138 OF THE MUNICIPAL CORPORATION ACT
========================================================================
Before: The Assessor & Collector / Municipal Valuation Tribunal,
Assessment Year: $assessmentYear | UPIC / Property ID: $propertyUpicNumber

IN THE MATTER OF:
$ownerName (Assessee / Appellant)
VERSUS
Municipal Corporation Revenue Department (Respondent)

SUBJECT: Formal Objection against arbitrary property tax notice of ₹$municipalDemandedTax

The Appellant respectfully submits:
1. FACTUAL DISCREPANCY:
   - Covered Built-up Area: $coveredAreaSqMtr sq. meters (Residential)
   - Unit Area Value (UAV) Colony Classification: Category $colonyCategory
   - Legitimate Tax Payable under Unit Area Method: ₹$correctCalculatedTax
   - Arbitrary Assessment Notice Amount: ₹$municipalDemandedTax
   - Disputed Exorbitant Excess: ₹$disputedAmount

2. STATUTORY GROUNDS:
   The impugned demand is mathematically flawed, ignores the age factor rebate, 
   and wrongfully taxes open courtyard area contrary to Municipal Assessment Bye-Laws.

PRAYER:
a) Stay recovery proceedings and distress warrant regarding Property UPIC: $propertyUpicNumber.
b) Issue revised rectified assessment bill of ₹$correctCalculatedTax.
c) Grant virtual or personal hearing under Section 138(2).

Appellant: $ownerName via JanSeva Legal Portal.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 8: Street Vendors Act 2014 & Footpath Encroachment Deconfliction
// ----------------------------------------------------------------------------
class StreetVendingComplianceRecord {
  final String vendorCertificateId;
  final String vendorName;
  final String vendingZoneCategory; // Vending Zone, Non-Vending Zone, Restricted
  final bool isEncroachingPedestrianWalkway;
  final bool isExtortedByUnauthorizedPersons;

  const StreetVendingComplianceRecord({
    required this.vendorCertificateId,
    required this.vendorName,
    required this.vendingZoneCategory,
    required this.isEncroachingPedestrianWalkway,
    required this.isExtortedByUnauthorizedPersons,
  });

  String generateTownVendingCommitteePetition({required String wardName}) {
    return '''
========================================================================
REPRESENTATION UNDER STREET VENDORS ACT 2014 (PROTECTION OF LIVELIHOOD)
========================================================================
To:
The Town Vending Committee (TVC) & Ward Enforcement Wing,
Ward: $wardName

SUBJECT: Vending Rights Protection & Pedestrian Right-of-Way Demarcation
VENDOR ID: $vendorCertificateId | VENDOR NAME: $vendorName

1. STATUTORY STATUS UNDER STREET VENDORS ACT, 2014:
   - Certificate of Vending (CoV) ID: $vendorCertificateId
   - Zone Category: $vendingZoneCategory
   - Harassment / Extortion Complaint: ${isExtortedByUnauthorizedPersons ? 'YES - POLICE GRIEVANCE ATTACHED' : 'None'}
   - Pedestrian Footpath Clear Passage: ${isEncroachingPedestrianWalkway ? 'NON-COMPLIANT - BARRICADE RESTRUCTURING NEEDED' : 'Clear'}

DEMANDS:
a) Protect legal vendor against arbitrary eviction under Section 3(3) of the Central Act.
b) Demarcate 1.5-meter yellow tactile pedestrian walking line on the footpath.
c) Ensure zero tolerance for illegal anti-social commercial encroachment while safeguarding registered vendors.

Submitted via JanSeva Town Vending Gateway.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 9: Noise Pollution Rules 2000 & SDM/Police 112 Restraint Order
// ----------------------------------------------------------------------------
class NoisePollutionViolationReport {
  final String locality;
  final String soundSource; // Commercial DG set, Banquet hall amplifier, Illegal construction
  final double measuredDecibels;
  final DateTime incidentTime;
  final bool isSilenceZone; // Within 100m of educational institution or hospital

  const NoisePollutionViolationReport({
    required this.locality,
    required this.soundSource,
    required this.measuredDecibels,
    required this.incidentTime,
    required this.isSilenceZone,
  });

  String generateNoiseRestraintPetition() {
    final permissible = isSilenceZone ? 40.0 : 45.0; // Night-time standard
    final excess = measuredDecibels - permissible;
    return '''
========================================================================
EMERGENCY COMPLAINT UNDER NOISE POLLUTION (REGULATION & CONTROL) RULES, 2000
========================================================================
To:
1. The Station House Officer (SHO), Local Police Station
2. The Sub-Divisional Magistrate (SDM), Environment Cell
Locality: $locality

SUBJECT: Urgent seizure of sound source violating Night-Time Noise Standards
TIME: ${incidentTime.toIso8601String().substring(11, 16)} hrs | SOURCE: $soundSource

1. MEASUREMENT & CRIME PARTICULARS:
   - Area Classification: ${isSilenceZone ? 'SILENCE ZONE (Hospital/School)' : 'Residential Zone'}
   - Permissible Night-Time Limit: $permissible dB(A) Leq
   - Measured Ambient Level: $measuredDecibels dB(A) Leq
   - Statutory Breach: +$excess dB(A) excess above permissible law

2. STATUTORY POWERS UNDER RULE 5 & 8:
   The authority is empowered to seize audio equipment, impound un-muffled diesel generators, 
   and prosecute under Section 19 of the Environment (Protection) Act, 1986.

REQUEST:
Immediate police dispatch via Emergency 112 to stop emission and confiscate equipment.

Dispatched via JanSeva Environmental Sentinel.
''';
  }
}

// ----------------------------------------------------------------------------
// LOOP 10: Safe City Dark-Spot & Streetlight Maintenance SLA Auditor
// ----------------------------------------------------------------------------
class StreetlightDarkSpotAudit {
  final String poleNumber;
  final String streetName;
  final String wardName;
  final int consecutiveDarkPoles;
  final bool isWomenTransitCorridor;
  final int daysDark;

  const StreetlightDarkSpotAudit({
    required this.poleNumber,
    required this.streetName,
    required this.wardName,
    required this.consecutiveDarkPoles,
    required this.isWomenTransitCorridor,
    required this.daysDark,
  });

  String generateSafeCityLightingPetition() {
    return '''
========================================================================
SAFE CITY PROJECT: STATUTORY DARK-SPOT RECTIFICATION & LIGHTING AUDIT
========================================================================
To:
The Nodal Officer, Smart City Street Lighting (EESL / DISCOM Maintenance Wing),
Ward: $wardName | Corridor: $streetName

SUBJECT: Non-functioning street lighting creating dangerous dark-spot corridor
POLE ID: $poleNumber | CONSECUTIVE UNLIT POLES: $consecutiveDarkPoles

Respected Sir/Madam,
Under the Safe City Project guidelines and Municipal Energy Services Agreement:
1. Location: $streetName (Ward $wardName)
2. Darkness Duration: $daysDark consecutive nights
3. Women Transit Safety Hazard: ${isWomenTransitCorridor ? 'HIGH-RISK WOMEN COMMUTE ROUTE' : 'Standard'}
4. Statutory Contract SLA: Maximum 48 hours for LED luminaire / MCB repair.

DEMAND:
Emergency replacement of faulty LED fixtures and testing of underground feeder cable within 24 hours.

Dispatched via JanSeva Women Safety & Urban Lighting Cell.
''';
  }
}
