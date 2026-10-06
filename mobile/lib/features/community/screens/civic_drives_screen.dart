import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/civic_drive.dart';

class CivicDrivesScreen extends StatefulWidget {
  final bool isHindi;

  const CivicDrivesScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<CivicDrivesScreen> createState() => _CivicDrivesScreenState();
}

class _CivicDrivesScreenState extends State<CivicDrivesScreen> {
  late List<CivicDrive> _drives;

  @override
  void initState() {
    super.initState();
    _drives = [
      CivicDrive(
        id: 'DRV-101',
        title: 'Ward 14 Mega Swachhata Shramdaan',
        description: 'Community cleanup of central market area, segregate plastic waste and paint kerbs.',
        ward: 'Ward 14',
        organizer: 'JanSeva Youth Club & SWM Dept',
        scheduledDate: DateTime.now().add(const Duration(days: 3)),
        targetVolunteers: 50,
        registeredVolunteers: 38,
        driveType: 'cleanliness_swachhata',
        isUserRegistered: true,
      ),
      CivicDrive(
        id: 'DRV-102',
        title: 'Amrit Sarovar Native Tree Plantation',
        description: 'Planting 200 native Neem and Peepal saplings along the revitalized lake bund.',
        ward: 'Ward 08',
        organizer: 'Green JanSeva Foundation',
        scheduledDate: DateTime.now().add(const Duration(days: 6)),
        targetVolunteers: 100,
        registeredVolunteers: 64,
        driveType: 'tree_plantation',
        isUserRegistered: false,
      ),
    ];
  }

  void _toggleRsvp(String driveId) {
    setState(() {
      _drives = _drives.map((d) {
        if (d.id == driveId) {
          final isRegistered = !d.isUserRegistered;
          return d.copyWith(
            isUserRegistered: isRegistered,
            registeredVolunteers: isRegistered
                ? d.registeredVolunteers + 1
                : (d.registeredVolunteers - 1).clamp(0, 9999),
          );
        }
        return d;
      }).toList();
    });

    final target = _drives.firstWhere((d) => d.id == driveId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          target.isUserRegistered
              ? (widget.isHindi ? 'पंजीकरण सफल! धन्यवाद।' : 'RSVP Confirmed! Thank you volunteer.')
              : (widget.isHindi ? 'पंजीकरण रद्द किया गया।' : 'RSVP Cancelled.'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'नागरिक स्वयंसेवक अभियान' : 'Civic Volunteer Drives',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isHi ? 'सामुदायिक सेवा और पर्यावरण' : 'Community Action Hub',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHi
                        ? 'अपने वार्ड को स्वच्छ और हरा-भरा बनाने के लिए नागरिक स्वयंसेवक बनें।'
                        : 'Join hands with fellow citizens and municipal teams to create greener, cleaner wards.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isHi ? 'सक्रिय अभियान (Active Drives)' : 'Upcoming Civic Drives',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ..._drives.map((drive) => _buildDriveCard(drive, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildDriveCard(CivicDrive drive, bool isHi) {
    final isGreen = drive.driveType == 'tree_plantation';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: drive.isUserRegistered ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: drive.isUserRegistered ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGreen ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isGreen ? Icons.forest_rounded : Icons.cleaning_services_rounded,
                  size: 20,
                  color: isGreen ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drive.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${drive.ward} • ${drive.organizer}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            drive.description,
            style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: drive.participationProgress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isGreen ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${drive.registeredVolunteers}/${drive.targetVolunteers} ${isHi ? 'स्वयंसेवक' : 'volunteers'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(drive.participationProgress * 100).toInt()}% ${isHi ? 'पूर्ण' : 'filled'}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom Actions
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    '${drive.scheduledDate.day}/${drive.scheduledDate.month}/${drive.scheduledDate.year}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                key: Key('rsvp_btn_${drive.id}'),
                onPressed: () => _toggleRsvp(drive.id),
                icon: Icon(
                  drive.isUserRegistered ? Icons.check_circle_rounded : Icons.how_to_reg_rounded,
                  size: 16,
                ),
                label: Text(
                  drive.isUserRegistered
                      ? (isHi ? 'पंजीकृत (Cancel)' : 'Registered')
                      : (isHi ? 'शामिल हों (RSVP)' : 'Join Drive'),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: drive.isUserRegistered ? const Color(0xFF10B981) : const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
