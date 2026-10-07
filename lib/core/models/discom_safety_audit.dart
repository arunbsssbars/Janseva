/// Electrical Safety & SERC Standards of Performance (SOP) regulations
class DiscomHazardReport {
  final String caNumber; // Consumer Account Number
  final String discomName;
  final String feederName;
  final String transformerId;
  final String subDivision;
  final bool hasLooseHangingWire;
  final bool hasTransformerSparking;
  final bool hasHighVoltageSurge;
  final int outageHours;
  final double estimatedApplianceLossInRupees;

  const DiscomHazardReport({
    required this.caNumber,
    required this.discomName,
    required this.feederName,
    required this.transformerId,
    required this.subDivision,
    required this.hasLooseHangingWire,
    required this.hasTransformerSparking,
    required this.hasHighVoltageSurge,
    required this.outageHours,
    this.estimatedApplianceLossInRupees = 0.0,
  });

  /// Computes mandatory SERC compensation for outage exceeding statutory SLA (typically 12 hrs urban)
  double computeOutagePenalty() {
    if (outageHours <= 12) return 0.0;
    final delayedHours = outageHours - 12;
    // Statutory rate: ₹50 per hour of unrectified outage beyond SLA
    return delayedHours * 50.0;
  }

  /// Drafts formal Notice to DISCOM Superintending Engineer & State Electricity Regulatory Commission
  String generateDiscomCompensationPetition() {
    final penalty = computeOutagePenalty();
    return '''
========================================================================
LEGAL COMPENSATION CLAIM UNDER SERC STANDARDS OF PERFORMANCE REGULATIONS
========================================================================
To:
1. The Executive Engineer / Superintending Engineer (Distribution)
   $discomName, Division: $subDivision
2. The Secretary, State Electricity Regulatory Commission (Consumer Redressal Forum)

SUBJECT: Demand for Statutory Compensation & Emergency Hazard Rectification
CONSUMER CA NUMBER: $caNumber | TRANSFORMER ID: $transformerId | FEEDER: $feederName

Respected Authority,
Under the Electricity Act, 2003 and SERC Standards of Performance (SOP) Regulations, 
this formal claim is lodged regarding electrical failure and hazard in our locality:

1. HAZARD DETAILS:
   - Sparking / Oil Leakage in Distribution Transformer: ${hasTransformerSparking ? 'ACTIVE EXPLOSION HAZARD' : 'No'}
   - Low-hanging / Broken Live High Tension (HT) Wire: ${hasLooseHangingWire ? 'IMMEDIATE ELECTROCUTION DANGER' : 'No'}
   - High Voltage Surge (Neutral Wire Displacement): ${hasHighVoltageSurge ? 'Damaged Household Equipment' : 'No'}
   - Continuous Power Outage Duration: $outageHours Hours

2. STATUTORY COMPENSATION COMPUTATION:
   - Permissible Outage Limit: 12 Hours
   - Default Outage Beyond SLA: ${outageHours > 12 ? outageHours - 12 : 0} Hours
   - Mandatory SERC Compensation: ₹$penalty
   ${hasHighVoltageSurge ? '- Appliance Damage Indemnity Claim: ₹$estimatedApplianceLossInRupees' : ''}

DEMANDS:
a) Deploy the 24x7 Breakdown Line Squad immediately under Central Electricity Authority Safety Norms.
b) Credit ₹$penalty directly into the consumer electricity billing ledger for Consumer ID: $caNumber.
c) Conduct electrical inspectorate assessment of appliance burnout under Section 67 of the Electricity Act.

Dispatched via JanSeva Statutory Energy Redressal Module.
''';
  }
}
