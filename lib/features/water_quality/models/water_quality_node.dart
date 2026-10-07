enum WaterSafetyStatus {
  potable,
  acceptableWithBoiling,
  nonPotableAlert,
}

class WaterQualityNode {
  final String id;
  final String location;
  final String ward;
  final double phLevel;
  final int tds; // Total Dissolved Solids in ppm
  final double residualChlorine; // mg/L
  final double turbidity; // NTU
  final DateTime testedAt;

  const WaterQualityNode({
    required this.id,
    required this.location,
    required this.ward,
    required this.phLevel,
    required this.tds,
    required this.residualChlorine,
    required this.turbidity,
    required this.testedAt,
  });

  WaterSafetyStatus get safetyStatus {
    // BIS 10500 drinking water guidelines: pH 6.5-8.5, TDS < 500, Turbidity < 5 NTU
    if (phLevel >= 6.5 && phLevel <= 8.5 && tds <= 300 && turbidity <= 2.0 && residualChlorine >= 0.2) {
      return WaterSafetyStatus.potable;
    }
    if (phLevel >= 6.0 && phLevel <= 9.0 && tds <= 600 && turbidity <= 5.0) {
      return WaterSafetyStatus.acceptableWithBoiling;
    }
    return WaterSafetyStatus.nonPotableAlert;
  }
}
