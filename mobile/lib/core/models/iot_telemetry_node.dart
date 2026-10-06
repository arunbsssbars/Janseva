enum SensorHealth {
  onlineNormal,
  warningThreshold,
  criticalBreach,
  sensorOffline,
}

class AirQualitySensorNode {
  final String sensorId;
  final String location;
  final String ward;
  final int aqi;
  final double pm25;
  final double pm10;
  final SensorHealth health;
  final DateTime lastUpdated;

  const AirQualitySensorNode({
    required this.sensorId,
    required this.location,
    required this.ward,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.health,
    required this.lastUpdated,
  });

  String get aqiCategory {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 200) return 'Poor';
    if (aqi <= 300) return 'Very Poor';
    return 'Severe';
  }
}

class WaterSumpTelemetryNode {
  final String nodeId;
  final String reservoirName;
  final String ward;
  final double waterLevelMeters;
  final double capacityMeters;
  final double turbidityNtu;
  final SensorHealth health;

  const WaterSumpTelemetryNode({
    required this.nodeId,
    required this.reservoirName,
    required this.ward,
    required this.waterLevelMeters,
    required this.capacityMeters,
    required this.turbidityNtu,
    required this.health,
  });

  double get fullnessRatio =>
      capacityMeters > 0 ? (waterLevelMeters / capacityMeters).clamp(0.0, 1.0) : 0.0;
}
