import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/street_vendor_model.dart';

class StreetVendorScreen extends StatefulWidget {
  final bool isHindi;

  const StreetVendorScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<StreetVendorScreen> createState() => _StreetVendorScreenState();
}

class _StreetVendorScreenState extends State<StreetVendorScreen> {
  final StreetVendorCertificate _myCertificate = StreetVendorCertificate(
    certificateNumber: 'SVA-2026-WRD1-449',
    vendorName: 'Radhe Shyam Gupt',
    tradeCategory: 'Vegetables & Fruits',
    assignedZoneId: 'VZ-WRD1-NORTH',
    assignedSlotNumber: 'Slot #24',
    status: VendorLicenseStatus.activeValid,
    validTill: DateTime.now().add(const Duration(days: 280)),
  );

  final List<VendorVendingZone> _zones = const [
    VendorVendingZone(
      zoneId: 'VZ-WRD1-NORTH',
      zoneName: 'North Market Pedestrian Vending Zone',
      ward: 'Ward 1 - Civil Lines',
      totalPermittedSlots: 50,
      allocatedSlots: 42,
      hasDrinkingWater: true,
      hasWasteDisposalBin: true,
    ),
    VendorVendingZone(
      zoneId: 'VZ-WRD1-STN',
      zoneName: 'Old Railway Station Evening Bazaar',
      ward: 'Ward 1 - Civil Lines',
      totalPermittedSlots: 35,
      allocatedSlots: 35,
      hasDrinkingWater: true,
      hasWasteDisposalBin: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'स्ट्रीट वेंडर व वेंडिंग ज़ोन' : 'Street Vendor & Vending Zones',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Vendor ID Certificate Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.badge_rounded, color: Color(0xFF059669), size: 20),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isHi ? 'पीएम स्वनिधि वेंडर प्रमाण पत्र' : 'PM SVANidhi Vendor Certificate',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Active Valid',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _myCertificate.vendorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_myCertificate.tradeCategory} • ${_myCertificate.assignedSlotNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reg: ${_myCertificate.certificateNumber}',
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Designated Vending Zones
            Text(
              isHi ? 'वार्ड में निर्धारित वेंडिंग ज़ोन' : 'Municipal Vending Zones (${_zones.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ..._zones.map((zone) => _buildZoneCard(zone, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneCard(VendorVendingZone zone, bool isHi) {
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
                  zone.zoneName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: zone.isFull ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  zone.isFull ? 'Full' : '${zone.totalPermittedSlots - zone.allocatedSlots} open',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: zone.isFull ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            zone.ward,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (zone.hasDrinkingWater) ...[
                const Icon(Icons.water_drop_rounded, size: 12, color: Color(0xFF0284C7)),
                const SizedBox(width: 3),
                Text(isHi ? 'पेयजल' : 'Water', style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
                const SizedBox(width: 10),
              ],
              if (zone.hasWasteDisposalBin) ...[
                const Icon(Icons.delete_rounded, size: 12, color: Color(0xFF059669)),
                const SizedBox(width: 3),
                Text(isHi ? 'कूड़ेदान' : 'Bins', style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
