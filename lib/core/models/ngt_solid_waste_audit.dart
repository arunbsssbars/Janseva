/// Solid Waste Management Rules 2016 & National Green Tribunal (NGT) environmental compensation
class SolidWasteViolationReport {
  final String locationAddress;
  final String wardName;
  final String corporationName;
  final bool isOpenGarbageBurning;
  final bool isSecondaryDhalaoOverflow;
  final bool isLeachateFlowingOnRoad;
  final int daysAccumulated;
  final String sanitaryInspectorName;

  const SolidWasteViolationReport({
    required this.locationAddress,
    required this.wardName,
    required this.corporationName,
    required this.isOpenGarbageBurning,
    required this.isSecondaryDhalaoOverflow,
    required this.isLeachateFlowingOnRoad,
    required this.daysAccumulated,
    this.sanitaryInspectorName = 'Ward Sanitary Inspector',
  });

  /// NGT mandated Environmental Compensation fine schedule
  double computeStatutoryNgtFine() {
    double fine = 0.0;
    if (isOpenGarbageBurning) {
      fine += 5000.0; // ₹5,000 spot environmental compensation for open waste fire
    }
    if (isSecondaryDhalaoOverflow) {
      fine += daysAccumulated * 1000.0; // ₹1,000 per day of uncleared secondary dumping
    }
    return fine;
  }

  /// Drafts formal Notice to Member Secretary, State Pollution Control Board & Municipal Commissioner
  String generateNgtViolationPetition({required String complaintDocket}) {
    final fine = computeStatutoryNgtFine();
    return '''
========================================================================
STATUTORY NOTICE UNDER SOLID WASTE MANAGEMENT RULES 2016 & NGT DIRECTIVES
========================================================================
To:
1. The Member Secretary, State Pollution Control Board / Committee
2. The Municipal Commissioner / Chief Health Officer, $corporationName
Ward: $wardName | Location: $locationAddress

SUBJECT: Direct Violation of SWM Rules 2016 & Open Burning of Toxic Waste
DOCKET REFERENCE: $complaintDocket

Respected Authorities,
This petition reports gross non-compliance with the Solid Waste Management Rules, 2016 
and mandatory directions issued by the Hon'ble National Green Tribunal (Principal Bench, New Delhi).

VIOLATION SUMMARY:
- Open Burning of Waste/Plastics: ${isOpenGarbageBurning ? 'CONFIRMED (Toxic Dioxin / PM2.5 release)' : 'No'}
- Secondary Dump Overspill: ${isSecondaryDhalaoOverflow ? 'Severe (Accumulated $daysAccumulated Days)' : 'No'}
- Toxic Leachate Contamination: ${isLeachateFlowingOnRoad ? 'Active groundwater & road surface risk' : 'No'}
- Area In-charge: $sanitaryInspectorName

ENVIRONMENTAL COMPENSATION APPLICABLE:
As per Hon'ble NGT orders in OA No. 199/2014 & SWM Rule 15:
- Statutory Spot Environmental Compensation: ₹$fine

DEMANDS:
1. Immediate dispatch of mechanized compactor and suction vehicle to clear the site within 6 hours.
2. Dousing of fire and registration of challan against responsible personnel under Section 15 of EPA 1986.
3. Geo-tagging and daily biometric sweeping verification of this beat.

Reported by Vigilant Citizen via JanSeva Clean Air & Waste Sentinel.
''';
  }
}
