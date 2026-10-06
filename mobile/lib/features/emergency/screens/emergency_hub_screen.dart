import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/localization/civic_strings.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class EmergencyHelpline {
  final String title;
  final String titleHi;
  final String number;
  final String description;
  final IconData icon;
  final Color color;

  const EmergencyHelpline({
    required this.title,
    required this.titleHi,
    required this.number,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class EmergencyHubScreen extends StatelessWidget {
  final JanSevaState state;

  const EmergencyHubScreen({super.key, required this.state});

  static const List<EmergencyHelpline> helplines = [
    EmergencyHelpline(
      title: 'National Emergency',
      titleHi: 'राष्ट्रीय आपातकालीन सेवा',
      number: '112',
      description: 'Unified Emergency Services (Police, Fire, Medical)',
      icon: Icons.emergency,
      color: CivicColors.error,
    ),
    EmergencyHelpline(
      title: 'Municipal Control Room',
      titleHi: 'नगर निगम आपदा नियंत्रण',
      number: '1800-180-2026',
      description: '24x7 Water Logging, Cave-in & Tree Fall Cell',
      icon: Icons.location_city,
      color: CivicColors.primary,
    ),
    EmergencyHelpline(
      title: 'Electricity Emergency',
      titleHi: 'विद्युत आपातकालीन हेल्पलाइन',
      number: '1912',
      description: 'Live wire snaps, transformer spark & blackout',
      icon: Icons.bolt,
      color: Colors.amber,
    ),
    EmergencyHelpline(
      title: 'Ambulance & Trauma',
      titleHi: 'एम्बुलेंस एवं ट्रॉमा सेवा',
      number: '108',
      description: 'Government Free Medical Emergency Fleet',
      icon: Icons.medical_services,
      color: CivicColors.success,
    ),
  ];

  Future<void> _reportImmediateHazard(BuildContext context, String hazardType) async {
    final isHindi = state.isHindi;
    final created = await state.createGrievance(
      title: 'CRITICAL HAZARD: $hazardType',
      description: 'Automated rapid emergency dispatch triggered by citizen at immediate danger site.',
      category: GrievanceCategory.publicSafetyAndHazards,
      priority: GrievancePriority.emergency,
      wardId: 'W-01',
      wardName: 'Civil Lines',
      address: 'GPS Pinpoint: 28.6139° N, 77.2090° E',
      landmark: 'Emergency Quick Dispatch',
      latitude: 28.6139,
      longitude: 77.2090,
    );

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning, color: CivicColors.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHindi ? 'आपातकालीन चेतावनी भेजी गई' : 'Emergency Alert Dispatched',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: Text(
            isHindi
                ? 'शिकायत #${created.id} को सर्वोच्च प्राथमिकता के साथ नगर निगम आपदा सेल को भेज दिया गया है। त्वरित प्रतिक्रिया दल रवाना हो रहा है।'
                : 'Ticket #${created.id} was dispatched directly to the Municipal Disaster Cell. Priority response team notified.',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: CivicColors.error),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = state.isHindi;

    return ResponsiveScaffold(
      appBar: AppBar(
        backgroundColor: CivicColors.error,
        title: Text(CivicStrings.get('emergency', isHindi: isHindi)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Urgent Alert Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CivicColors.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CivicColors.error),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.crisis_alert, color: CivicColors.error, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          CivicStrings.get('sosTitle', isHindi: isHindi),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: CivicColors.error,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CivicStrings.get('sosSubtitle', isHindi: isHindi),
                    style: const TextStyle(fontSize: 12, color: CivicColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Hazard SOS Triggers
            Text(
              isHindi ? 'त्वरित संकट चेतावनी (1-टैप डिस्पैच)' : 'Rapid Hazard Dispatch (1-Tap SOS)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildSosQuickButton(
                    context: context,
                    label: isHindi ? 'बिजली का तार टूटा' : 'Live Wire Snapped',
                    icon: Icons.flash_on,
                    color: Colors.amber.shade800,
                    onTap: () => _reportImmediateHazard(context, 'Live Electric Wire Snapped'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSosQuickButton(
                    context: context,
                    label: isHindi ? 'सड़क धंसी / गड्ढा' : 'Road Cave-In',
                    icon: Icons.dangerous,
                    color: CivicColors.error,
                    onTap: () => _reportImmediateHazard(context, 'Severe Road Cave-In Collapse'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildSosQuickButton(
                    context: context,
                    label: isHindi ? 'सीवर / बाढ़ जलभराव' : 'Sewer Backflow Flood',
                    icon: Icons.water,
                    color: Colors.blue.shade700,
                    onTap: () => _reportImmediateHazard(context, 'Toxic Sewer Backflow Hazard'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSosQuickButton(
                    context: context,
                    label: isHindi ? 'गैस रिसाव / आग' : 'Gas Leak / Fire',
                    icon: Icons.local_fire_department,
                    color: Colors.deepOrange,
                    onTap: () => _reportImmediateHazard(context, 'Gas Leak / Hazardous Fire Risk'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Emergency Helplines Directory
            Text(
              isHindi ? '24x7 आपातकालीन नंबर' : '24x7 Emergency Hotlines',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...helplines.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: item.color.withValues(alpha: 0.15),
                        radius: 20,
                        child: Icon(item.icon, color: item.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi ? item.titleHi : item.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.description,
                              style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.color,
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Dialing ${item.number} (${item.title})...')),
                          );
                        },
                        child: Text(
                          item.number,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSosQuickButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
