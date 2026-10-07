/// Real-life potable water quality standards under Bureau of Indian Standards (BIS 10500:2012)
class WaterQualityTestReport {
  final double phLevel; // Acceptable 6.5 - 8.5
  final double turbidityNtu; // Acceptable max 1.0 NTU, permissible 5.0 NTU
  final double tdsPpm; // Acceptable max 500 ppm, permissible 2000 ppm
  final double residualChlorinePpm; // Min 0.2 ppm for disinfection
  final int coliformCountPer100ml; // Must be 0 for potable water
  final bool hasFecalOdor;

  const WaterQualityTestReport({
    required this.phLevel,
    required this.turbidityNtu,
    required this.tdsPpm,
    required this.residualChlorinePpm,
    required this.coliformCountPer100ml,
    required this.hasFecalOdor,
  });

  bool get isSafeToDrink =>
      phLevel >= 6.5 &&
      phLevel <= 8.5 &&
      turbidityNtu <= 5.0 &&
      coliformCountPer100ml == 0 &&
      !hasFecalOdor;

  List<String> get criticalViolations {
    final list = <String>[];
    if (coliformCountPer100ml > 0) {
      list.add('Severe Microbial Contamination: $coliformCountPer100ml Coliform CFU/100ml (Risk of Cholera/Typhoid)');
    }
    if (hasFecalOdor) {
      list.add('Sewage Infiltration: Fecal sewer cross-contamination detected in potable line');
    }
    if (residualChlorinePpm < 0.2) {
      list.add('Disinfection Failure: Residual Chlorine $residualChlorinePpm mg/L below statutory 0.2 mg/L requirement');
    }
    if (turbidityNtu > 5.0) {
      list.add('Excess Turbidity: $turbidityNtu NTU exceeds BIS 10500 max limit (5.0 NTU)');
    }
    return list;
  }

  /// Drafts formal Requisition to Jal Board Chief Chemist and District Health Officer
  String generateLabRequisitionPetition({
    required String locality,
    required String wardName,
    required String consumerKNumber,
  }) {
    final violations = criticalViolations;
    return '''
========================================================================
STATUTORY WATER TESTING REQUISITION UNDER BIS 10500:2012 & PUBLIC HEALTH ACT
========================================================================
To:
1. The Chief Chemist / Quality Control Laboratory, Water Works Department / Jal Board
2. The District Health Officer / Chief Medical Officer (CMO)
Ward: $wardName | Locality: $locality

SUBJECT: Urgent sample collection and microbiological testing of contaminated tap supply
CONSUMER K-NO / CONNECTION ID: $consumerKNumber

Respected Authority,
Residents of $locality (Ward $wardName) are receiving contaminated tap water supply 
which violates the mandatory drinking water parameters under BIS 10500:2012.

PRELIMINARY HAZARD ASSESSMENT:
- Turbidity: $turbidityNtu NTU
- Residual Free Chlorine: $residualChlorinePpm mg/L
- Fecal Sewer Odor: ${hasFecalOdor ? 'POSITIVE (CRITICAL RISK)' : 'Negative'}
- Suspected Coliform: ${coliformCountPer100ml > 0 ? '$coliformCountPer100ml CFU/100ml' : 'Present'}

ACTIVE HAZARDS:
${violations.map((v) => '  • $v').join('\n')}

STATUTORY DEMANDS UNDER PUBLIC HEALTH LAWS:
1. Dispatch of Mobile Water Testing Van within 12 hours to collect certified samples.
2. Immediate deployment of clean municipal drinking water tankers to $locality.
3. Isolation and acoustic inspection of underground water mains for sewer line cross-leakage.
4. Issue of boil-water advisory until microbiological test report confirms zero E. Coli.

Filed under urgency for disease outbreak prevention via JanSeva Platform.
''';
  }
}
