import 'package:flutter/material.dart';
import '../../../../core/theme/civic_colors.dart';
import '../models/aqi_station.dart';
import '../services/aqi_service.dart';

class AirQualityScreen extends StatefulWidget {
  final bool isHindi;

  const AirQualityScreen({super.key, this.isHindi = false});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  late List<AqiStation> _stations;
  String _selectedWardFilter = 'All';

  @override
  void initState() {
    super.initState();
    _stations = AqiService.getLiveStations();
  }

  Color _getCategoryColor(AqiCategory category) {
    switch (category) {
      case AqiCategory.good:
        return const Color(0xFF10B981);
      case AqiCategory.moderate:
        return const Color(0xFFF59E0B);
      case AqiCategory.poor:
        return const Color(0xFFF97316);
      case AqiCategory.veryPoor:
        return const Color(0xFFEF4444);
      case AqiCategory.severe:
        return const Color(0xFF7F1D1D);
    }
  }

  String _getCategoryTitle(AqiCategory category, bool isHindi) {
    switch (category) {
      case AqiCategory.good:
        return isHindi ? 'अच्छा (Good)' : 'Good';
      case AqiCategory.moderate:
        return isHindi ? 'मध्यम (Moderate)' : 'Moderate';
      case AqiCategory.poor:
        return isHindi ? 'खराब (Poor)' : 'Poor';
      case AqiCategory.veryPoor:
        return isHindi ? 'बहुत खराब (Very Poor)' : 'Very Poor';
      case AqiCategory.severe:
        return isHindi ? 'गंभीर (Severe)' : 'Severe';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.isHindi;
    final filteredStations = _selectedWardFilter == 'All'
        ? _stations
        : _stations.where((s) => s.ward.contains(_selectedWardFilter)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'वायु गुणवत्ता सूचकांक (AQI)' : 'Air Quality Index (AQI)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: CivicColors.primary,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12.0 : 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.air, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isHindi
                                  ? 'लाइव वार्ड वायु मॉनिटरिंग'
                                  : 'Live Ward Air Monitoring',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isHindi ? 'सक्रिय सेंसर: 4' : 'Active: 4',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isHindi
                          ? 'CPCB मानकों के अनुसार 24 घंटे का रीयल-टाइम वायु गुणवत्ता विश्लेषण।'
                          : 'Real-time telemetry updated every 15 minutes conforming to CPCB guidelines.',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Filter Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: _selectedWardFilter == 'All',
                          label: Text(isHindi ? 'सभी वार्ड' : 'All Wards'),
                          onSelected: (_) => setState(() => _selectedWardFilter = 'All'),
                        ),
                      ),
                      ...['Ward 1', 'Ward 2', 'Ward 3', 'Ward 4'].map((w) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            selected: _selectedWardFilter == w,
                            label: Text(w),
                            onSelected: (_) => setState(() => _selectedWardFilter = w),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Stations List
                ...filteredStations.map((station) {
                  final catColor = _getCategoryColor(station.category);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: catColor.withValues(alpha: 0.3), width: 1.5),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${station.ward} • ${station.dominantPollutant}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: CivicColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: catColor),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${station.aqi}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        color: catColor,
                                      ),
                                    ),
                                    Text(
                                      'AQI',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: catColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getCategoryTitle(station.category, isHindi),
                              style: TextStyle(
                                color: catColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isHindi ? station.advisoryHi : station.advisoryEn,
                            style: const TextStyle(fontSize: 12, color: CivicColors.textPrimary),
                          ),
                          const Divider(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                'PM2.5: ${station.pm25} µg/m³',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'PM10: ${station.pm10} µg/m³',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'NO2: ${station.no2} ppb',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
