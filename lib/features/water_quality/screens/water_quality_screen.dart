import 'package:flutter/material.dart';
import '../../../../core/theme/civic_colors.dart';
import '../models/water_quality_node.dart';
import '../services/water_quality_service.dart';

class WaterQualityScreen extends StatefulWidget {
  final bool isHindi;

  const WaterQualityScreen({super.key, this.isHindi = false});

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  late List<WaterQualityNode> _nodes;
  String _selectedWardFilter = 'All';

  @override
  void initState() {
    super.initState();
    _nodes = WaterQualityService.getLiveNodes();
  }

  Color _getStatusColor(WaterSafetyStatus status) {
    switch (status) {
      case WaterSafetyStatus.potable:
        return const Color(0xFF059669);
      case WaterSafetyStatus.acceptableWithBoiling:
        return const Color(0xFFD97706);
      case WaterSafetyStatus.nonPotableAlert:
        return const Color(0xFFDC2626);
    }
  }

  String _getStatusTitle(WaterSafetyStatus status, bool isHindi) {
    switch (status) {
      case WaterSafetyStatus.potable:
        return isHindi ? 'सुरक्षित पेयजल (Safe Potable)' : 'Safe Potable';
      case WaterSafetyStatus.acceptableWithBoiling:
        return isHindi ? 'उबालकर पिएं (Boil Before Use)' : 'Boil Before Use';
      case WaterSafetyStatus.nonPotableAlert:
        return isHindi ? 'असुरक्षित जल चेतावनी (Unsafe Alert)' : 'Unsafe Water Alert';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.isHindi;
    final filtered = _selectedWardFilter == 'All'
        ? _nodes
        : _nodes.where((n) => n.ward.contains(_selectedWardFilter)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'पेयजल गुणवत्ता मॉनिटरिंग' : 'Drinking Water Quality',
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
                // Info Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.water_drop, color: Colors.white, size: 24),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isHindi
                                      ? 'लाइव जल परीक्षण नोड्स'
                                      : 'Live Water Test Nodes',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isHindi ? 'BIS 10500 मानक' : 'BIS 10500 Norms',
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
                            ? 'प्रत्येक वार्ड में ओवरहेड टैंकों व पाइपलाइन पर स्वचालित सेंसर।'
                            : 'Automated municipal pipeline probes measuring pH, TDS, Chlorine & Turbidity.',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Filters
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

                // Nodes List
                ...filtered.map((node) {
                  final statusColor = _getStatusColor(node.safetyStatus);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 1.5),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    node.location,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    node.ward,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: CivicColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  _getStatusTitle(node.safetyStatus, isHindi),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Chemical Metrics Grid
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              _buildMetricItem('pH', '${node.phLevel}', '6.5 - 8.5'),
                              _buildMetricItem('TDS', '${node.tds} ppm', '< 500 ppm'),
                              _buildMetricItem('Chlorine', '${node.residualChlorine} mg/L', '≥ 0.2 mg/L'),
                              _buildMetricItem('Turbidity', '${node.turbidity} NTU', '< 5.0 NTU'),
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

  Widget _buildMetricItem(String label, String value, String ideal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: CivicColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 1),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: CivicColors.textPrimary)),
        Text('Ideal: $ideal', style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
