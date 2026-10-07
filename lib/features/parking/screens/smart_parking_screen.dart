import 'package:flutter/material.dart';
import '../../../../core/theme/civic_colors.dart';
import '../models/parking_spot.dart';
import '../services/parking_service.dart';

class SmartParkingScreen extends StatefulWidget {
  final bool isHindi;

  const SmartParkingScreen({super.key, this.isHindi = false});

  @override
  State<SmartParkingScreen> createState() => _SmartParkingScreenState();
}

class _SmartParkingScreenState extends State<SmartParkingScreen> {
  late List<ParkingSpot> _spots;
  bool _evOnlyFilter = false;
  String _selectedWardFilter = 'All';

  @override
  void initState() {
    super.initState();
    _spots = ParkingService.getLiveParkingSpots();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.isHindi;
    final filtered = _spots.where((s) {
      if (_evOnlyFilter && !s.hasEvCharging) return false;
      if (_selectedWardFilter != 'All' && !s.ward.contains(_selectedWardFilter)) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'स्मार्ट म्युनिसिपल पार्किंग' : 'Smart Municipal Parking',
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
                      colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
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
                              const Icon(Icons.local_parking, color: Colors.white, size: 24),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isHindi
                                      ? 'लाइव स्लॉट उपलब्धता'
                                      : 'Live Slot Availability',
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
                              isHindi ? 'IoT सेंसर कनेक्टेड' : 'IoT Sensors Active',
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
                            ? 'फास्टैग आधारित स्वचालित प्रवेश एवं ई-वाहन चार्जिंग स्लॉट्स।'
                            : 'FASTag integrated automated boom barriers and live EV charging slots.',
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
                          avatar: const Icon(Icons.ev_station, size: 16),
                          selected: _evOnlyFilter,
                          label: Text(isHindi ? 'केवल ईवी चार्जिंग' : 'EV Charging Only'),
                          onSelected: (val) => setState(() => _evOnlyFilter = val),
                        ),
                      ),
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

                // Parking Lots List
                ...filtered.map((spot) {
                  final isAlmostFull = spot.isHighDemand;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                                      spot.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${spot.ward} • ${spot.address}',
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
                                  color: isAlmostFull
                                      ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                                      : const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${spot.availableSlots}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        color: isAlmostFull
                                            ? const Color(0xFFEF4444)
                                            : const Color(0xFF10B981),
                                      ),
                                    ),
                                    Text(
                                      isHindi ? 'खाली' : 'Free',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isAlmostFull
                                            ? const Color(0xFFEF4444)
                                            : const Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Occupancy Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: spot.occupiedSlots / spot.totalSlots,
                              backgroundColor: Colors.grey.shade200,
                              color: isAlmostFull ? Colors.orange : CivicColors.primary,
                              minHeight: 6,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '${spot.occupiedSlots}/${spot.totalSlots} ${isHindi ? 'भरे हुए' : 'Occupied'}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              const Text('•', style: TextStyle(color: Colors.grey)),
                              Text(
                                '₹${spot.hourlyRate.toInt()}/hr',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                              if (spot.hasEvCharging) ...[
                                const Text('•', style: TextStyle(color: Colors.grey)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.green.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.bolt, size: 12, color: Colors.green),
                                      const SizedBox(width: 2),
                                      Text(
                                        isHindi ? 'ईवी चार्जिंग' : 'EV Charging',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
