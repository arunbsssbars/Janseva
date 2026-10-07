import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/animal_rescue_report.dart';

class AnimalRescueScreen extends StatefulWidget {
  final bool isHindi;

  const AnimalRescueScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<AnimalRescueScreen> createState() => _AnimalRescueScreenState();
}

class _AnimalRescueScreenState extends State<AnimalRescueScreen> {
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedSpecies = 'Dog';
  final AnimalCondition _selectedCondition = AnimalCondition.injured;
  final RescueUrgency _selectedUrgency = RescueUrgency.immediateCritical;

  final List<AnimalRescueReport> _reports = [
    AnimalRescueReport(
      reportId: 'VET-2026-031',
      species: 'Dog',
      condition: AnimalCondition.injured,
      urgency: RescueUrgency.immediateCritical,
      locationAddress: 'Sector 5 Near Community Hospital Gate',
      ward: 'Ward 14',
      reporterContact: '+91 98765 43210',
      status: 'Dispatched Ambulance',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    AnimalRescueReport(
      reportId: 'VET-2026-018',
      species: 'Cattle',
      condition: AnimalCondition.trapped,
      urgency: RescueUrgency.urgent,
      locationAddress: 'Drainage Culvert behind Sabzi Mandi',
      ward: 'Ward 04',
      reporterContact: '+91 91234 56789',
      status: 'Treated & Released',
      reportedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isHindi ? 'कृपया स्थान दर्ज करें।' : 'Please enter location address.',
          ),
        ),
      );
      return;
    }

    final newReport = AnimalRescueReport(
      reportId: 'VET-2026-${_reports.length + 101}',
      species: _selectedSpecies,
      condition: _selectedCondition,
      urgency: _selectedUrgency,
      locationAddress: _locationController.text.trim(),
      ward: 'Ward 01',
      reporterContact: _contactController.text.trim().isEmpty ? '+91 99999 00000' : _contactController.text.trim(),
      status: 'Dispatched Ambulance',
      reportedAt: DateTime.now(),
    );

    setState(() {
      _reports.insert(0, newReport);
      _locationController.clear();
      _contactController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isHindi
              ? 'पशु बचाव एम्बुलेंस दल रवाना किया गया!'
              : 'Veterinary Ambulance dispatched to coordinates!',
        ),
        backgroundColor: const Color(0xFF047857),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'पशु बचाव व चिकित्सा आपातकाल' : 'Stray Animal & Veterinary Rescue',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF047857),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hotline Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pets_rounded, color: Color(0xFF059669), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHi ? '24x7 नगर निगम पशु चिकित्सा हेल्पलाइन' : '24x7 Municipal Animal Ambulance',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHi
                              ? 'घायल, फंसे या बीमार बेजुबान जानवरों के लिए त्वरित रेस्क्यू सेवा।'
                              : 'Rapid triage ambulance & certified veterinary first-response unit.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF047857)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Triage Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHi ? 'आपातकालीन बचाव रिपोर्ट करें' : 'Dispatch Veterinary Rescue',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSpecies,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: isHi ? 'जीव का प्रकार' : 'Species',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: ['Dog', 'Cat', 'Cattle', 'Monkey', 'Bird']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSpecies = v ?? 'Dog'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('animal_location_field'),
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: isHi ? 'घटनास्थल / लैंडमार्क' : 'Spot Location / Landmark',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('animal_contact_field'),
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: isHi ? 'संपर्क मोबाइल नंबर' : 'Contact Phone (For Ambulance ETA)',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('dispatch_rescue_btn'),
                      onPressed: _submitReport,
                      icon: const Icon(Icons.emergency_rounded, size: 16),
                      label: Text(
                        isHi ? 'तुरंत एम्बुलेंस भेजें' : 'Dispatch Animal Ambulance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active rescue missions
            Text(
              isHi ? 'सक्रिय पशु बचाव मिशन' : 'Active Rescue Missions (${_reports.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            ..._reports.map((report) => _buildReportCard(report, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(AnimalRescueReport report, bool isHi) {
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
                  '${report.reportId} • ${report.species}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            report.locationAddress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Contact: ${report.reporterContact}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${report.reportedAt.hour.toString().padLeft(2, '0')}:${report.reportedAt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
