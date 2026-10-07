import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/heat_resilience_data.dart';

class HeatResilienceScreen extends StatefulWidget {
  final bool isHindi;

  const HeatResilienceScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<HeatResilienceScreen> createState() => _HeatResilienceScreenState();
}

class _HeatResilienceScreenState extends State<HeatResilienceScreen> {
  final WardHeatIndex _heatData = const WardHeatIndex(
    ward: 'Ward 1 - Civil Lines',
    currentTempC: 41.5,
    heatIndexC: 45.8,
    alertLevel: HeatAlertLevel.extremeCaution,
    advisory: 'Severe afternoon heatwave conditions. Stay hydrated and avoid direct outdoor exposure between 12 PM - 4 PM.',
  );

  final List<CoolingCenter> _coolingCenters = const [
    CoolingCenter(
      id: 'COOL-01',
      name: 'Dr. Ambedkar Community Cooling Shelter',
      address: 'Main Market Square, Civil Lines',
      ward: 'Ward 1',
      capacity: 120,
      currentOccupancy: 45,
      hasFreeWater: true,
      hasOrsPackets: true,
      hasMistingCooler: true,
    ),
    CoolingCenter(
      id: 'COOL-02',
      name: 'Municipal Ward Library Air-Conditioned Hall',
      address: 'Near Gandhi Stadium, Ward 1',
      ward: 'Ward 1',
      capacity: 80,
      currentOccupancy: 62,
      hasFreeWater: true,
      hasOrsPackets: true,
      hasMistingCooler: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'लू व शहरी जलवायु अनुकूलन' : 'Urban Heat & Climate Resilience',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFFC2410C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Heatwave Alert Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              isHi ? 'लू चेतावनी स्तर: नारंगी (Orange)' : 'Heat Alert: Extreme Caution',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_heatData.currentTempC}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Real Feel (Heat Index): ${_heatData.heatIndexC}°C',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _heatData.advisory,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Free municipal water & ORS points
            Text(
              isHi ? 'समीप सार्वजनिक कूलिंग शेल्टर (Cooling Centers)' : 'Nearby Municipal Cooling Shelters (${_coolingCenters.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ..._coolingCenters.map((center) => _buildCenterCard(center, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCard(CoolingCenter center, bool isHi) {
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
              Expanded(
                child: Text(
                  center.name,
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
                  '${center.currentOccupancy}/${center.capacity} ${isHi ? 'स्थान' : 'seats'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0369A1)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            center.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          // Amenities chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (center.hasFreeWater)
                _buildAmenityChip(Icons.water_drop_rounded, isHi ? 'मुफ्त पेयजल' : 'Drinking Water'),
              if (center.hasOrsPackets)
                _buildAmenityChip(Icons.medication_liquid_rounded, isHi ? 'ORS पैकेट' : 'Free ORS'),
              if (center.hasMistingCooler)
                _buildAmenityChip(Icons.air_rounded, isHi ? 'मिस्टिंग कूलर' : 'Misting Coolers'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF0284C7)),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}
