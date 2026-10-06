import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/iot_telemetry_node.dart';

class IotTelemetryScreen extends StatefulWidget {
  final bool isHindi;

  const IotTelemetryScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<IotTelemetryScreen> createState() => _IotTelemetryScreenState();
}

class _IotTelemetryScreenState extends State<IotTelemetryScreen> {
  final List<AirQualitySensorNode> _airSensors = [
    AirQualitySensorNode(
      sensorId: 'AQI-WRD1-01',
      location: 'Civil Lines Central Crossroad',
      ward: 'Ward 1',
      aqi: 142,
      pm25: 58.4,
      pm10: 112.0,
      health: SensorHealth.onlineNormal,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AirQualitySensorNode(
      sensorId: 'AQI-WRD3-04',
      location: 'Industrial Estate Phase II',
      ward: 'Ward 3',
      aqi: 285,
      pm25: 124.6,
      pm10: 240.5,
      health: SensorHealth.warningThreshold,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  final List<WaterSumpTelemetryNode> _sumpSensors = [
    const WaterSumpTelemetryNode(
      nodeId: 'SMP-WRD1-NORTH',
      reservoirName: 'Civil Lines Overhead Tank A',
      ward: 'Ward 1',
      waterLevelMeters: 8.4,
      capacityMeters: 10.0,
      turbidityNtu: 1.2,
      health: SensorHealth.onlineNormal,
    ),
    const WaterSumpTelemetryNode(
      nodeId: 'SMP-WRD2-EAST',
      reservoirName: 'Gandhi Nagar Sub-Surface Sump',
      ward: 'Ward 2',
      waterLevelMeters: 2.1,
      capacityMeters: 9.0,
      turbidityNtu: 3.8,
      health: SensorHealth.warningThreshold,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'आईओटी सेंसर टेलीमेट्री व निगरानी' : 'IoT Sensors & Environmental Telemetry',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Live status banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sensors_rounded, color: Color(0xFF38BDF8), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHi ? 'वार्ड सेंसर नेटवर्क (सक्रिय 4/4)' : 'Ward Edge IoT Grid (4 Nodes Active)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHi
                              ? 'वायु प्रदूषण व जलाशय स्तर की रीयल-टाइम स्वचालित निगरानी।'
                              : 'Real-time telemetry feeding early civic hazard warnings.',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Air Quality Sensors
            Text(
              isHi ? 'वायु गुणवत्ता सेंसर (Air Quality)' : 'Ambient Air Quality Nodes (${_airSensors.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            ..._airSensors.map((node) => _buildAirSensorCard(node, isHi)),

            const SizedBox(height: 16),

            // Water Sump Sensors
            Text(
              isHi ? 'जल स्तर व जलाशय टेलीमेट्री (Water Sumps)' : 'Municipal Sump & Reservoir Telemetry (${_sumpSensors.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            ..._sumpSensors.map((node) => _buildSumpCard(node, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildAirSensorCard(AirQualitySensorNode node, bool isHi) {
    final isPoor = node.aqi > 200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  node.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPoor ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AQI ${node.aqi} • ${node.aqiCategory}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPoor ? const Color(0xFFDC2626) : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                'PM2.5: ${node.pm25} µg/m³  •  PM10: ${node.pm10} µg/m³',
                style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
              ),
              Text(
                node.sensorId,
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSumpCard(WaterSumpTelemetryNode node, bool isHi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  node.reservoirName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${(node.fullnessRatio * 100).toInt()}% Capacity',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: node.fullnessRatio,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                'Level: ${node.waterLevelMeters}m / ${node.capacityMeters}m  •  Turbidity: ${node.turbidityNtu} NTU',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                node.nodeId,
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
