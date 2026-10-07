enum HeatAlertLevel {
  normal,
  caution, // Yellow
  extremeCaution, // Orange
  danger, // Red
}

class CoolingCenter {
  final String id;
  final String name;
  final String address;
  final String ward;
  final bool hasFreeWater;
  final bool hasOrsPackets;
  final bool hasMistingCooler;
  final int capacity;
  final int currentOccupancy;

  const CoolingCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.ward,
    this.hasFreeWater = true,
    this.hasOrsPackets = true,
    this.hasMistingCooler = true,
    required this.capacity,
    required this.currentOccupancy,
  });

  double get occupancyRate => capacity > 0 ? (currentOccupancy / capacity).clamp(0.0, 1.0) : 0.0;
}

class WardHeatIndex {
  final String ward;
  final double currentTempC;
  final double heatIndexC;
  final HeatAlertLevel alertLevel;
  final String advisory;

  const WardHeatIndex({
    required this.ward,
    required this.currentTempC,
    required this.heatIndexC,
    required this.alertLevel,
    required this.advisory,
  });
}
