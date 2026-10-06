import 'package:flutter/material.dart';
import '../../../core/models/ward_notice.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class WardNoticesScreen extends StatefulWidget {
  final JanSevaState state;

  const WardNoticesScreen({super.key, required this.state});

  @override
  State<WardNoticesScreen> createState() => _WardNoticesScreenState();
}

class _WardNoticesScreenState extends State<WardNoticesScreen> {
  final List<WardNotice> _notices = WardNotice.defaultNotices();
  String? _selectedWardId;

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.state.isHindi;

    final filteredNotices = _notices.where((n) {
      if (_selectedWardId != null && n.wardId != _selectedWardId) return false;
      return true;
    }).toList();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'वार्ड सूचनाएं एवं जनसभा' : 'Ward Notices & Bulletins',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter by Ward row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    initialValue: _selectedWardId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: isHindi ? 'वार्ड द्वारा फ़िल्टर करें' : 'Filter by Ward',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(isHindi ? 'सभी वार्ड (शहर भर में)' : 'All Wards (Citywide)'),
                      ),
                      ...widget.state.wards.map((w) {
                        return DropdownMenuItem<String?>(
                          value: w.id,
                          child: Text(
                            'Ward ${w.wardNumber}: ${w.wardName}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (val) => setState(() => _selectedWardId = val),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notices Count
            Text(
              '${isHindi ? "सक्रिय सूचनाएं" : "Active Municipal Bulletins"} (${filteredNotices.length})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            ...filteredNotices.map((notice) => _buildNoticeCard(notice, isHindi)),

            if (filteredNotices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No active notices for this ward.'),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(WardNotice notice, bool isHindi) {
    Color badgeColor;
    String badgeLabel;

    switch (notice.urgency) {
      case NoticeUrgency.critical:
        badgeColor = CivicColors.error;
        badgeLabel = isHindi ? 'अति आवश्यक' : 'CRITICAL ALERT';
        break;
      case NoticeUrgency.advisory:
        badgeColor = CivicColors.warning;
        badgeLabel = isHindi ? 'सलाहकार' : 'ADVISORY';
        break;
      case NoticeUrgency.info:
        badgeColor = CivicColors.primary;
        badgeLabel = isHindi ? 'सार्वजनिक सूचना' : 'PUBLIC NOTICE';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: badgeColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notice.wardName,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: CivicColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isHindi ? notice.titleHi : notice.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              isHindi ? notice.descriptionHi : notice.description,
              style: const TextStyle(fontSize: 13, height: 1.35, color: CivicColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CivicColors.surfaceVariant,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.contact_phone_outlined, size: 16, color: CivicColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      notice.authorityContact,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
