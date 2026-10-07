import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/models/grievance.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../tracking/screens/grievance_detail_screen.dart';

class OfficerDashboardScreen extends StatefulWidget {
  final JanSevaState state;

  const OfficerDashboardScreen({super.key, required this.state});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  GrievanceStatus? _officerFilter;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;

    final allOfficerGrievances = state.grievances;
    final pendingTriageCount =
        allOfficerGrievances.where((g) => g.status == GrievanceStatus.submitted).length;
    final inProgressCount =
        allOfficerGrievances.where((g) => g.status == GrievanceStatus.inProgress).length;
    final breachedCount =
        allOfficerGrievances.where((g) => g.isSlaBreached && g.status.isActive).length;
    final resolvedCount =
        allOfficerGrievances.where((g) => g.status == GrievanceStatus.resolved || g.status == GrievanceStatus.verifiedClosed).length;

    final filteredList = allOfficerGrievances.where((g) {
      if (_officerFilter != null && g.status != _officerFilter) return false;
      return true;
    }).toList();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'वार्ड कार्यक्षेत्र' : 'Officer Workspace',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: isHindi ? 'नागरिक मोड' : 'Citizen Mode',
            onPressed: () => state.switchRole(UserRole.citizen),
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Officer Profile Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CivicColors.primaryDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 22,
                    child: Icon(Icons.badge, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.currentUser.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${state.currentUser.locality} • Official Dispatcher',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // KPI Grid
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Pending Triage',
                    count: pendingTriageCount,
                    color: CivicColors.statusSubmitted,
                    icon: Icons.inbox,
                    onTap: () => setState(() => _officerFilter = GrievanceStatus.submitted),
                    isSelected: _officerFilter == GrievanceStatus.submitted,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard(
                    title: 'In Progress',
                    count: inProgressCount,
                    color: CivicColors.statusInProgress,
                    icon: Icons.engineering,
                    onTap: () => setState(() => _officerFilter = GrievanceStatus.inProgress),
                    isSelected: _officerFilter == GrievanceStatus.inProgress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'SLA Breached',
                    count: breachedCount,
                    color: CivicColors.error,
                    icon: Icons.warning,
                    onTap: () => setState(() => _officerFilter = null),
                    isSelected: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Resolved',
                    count: resolvedCount,
                    color: CivicColors.success,
                    icon: Icons.check_circle,
                    onTap: () => setState(() => _officerFilter = GrievanceStatus.resolved),
                    isSelected: _officerFilter == GrievanceStatus.resolved,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Queue Header & Clear Filter
            Row(
              children: [
                Expanded(
                  child: Text(
                    _officerFilter == null
                        ? 'All Ward Complaints (${filteredList.length})'
                        : '${_officerFilter!.labelEn} (${filteredList.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_officerFilter != null)
                  TextButton(
                    onPressed: () => setState(() => _officerFilter = null),
                    child: const Text('Show All'),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // List of Grievances with Quick Officer Actions
            ...filteredList.map((g) => _buildOfficerGrievanceCard(g, isHindi)),

            if (filteredList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No grievances matching filter in this queue.'),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : CivicColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : CivicColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: color),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficerGrievanceCard(Grievance g, bool isHindi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CivicCategoryChip(category: g.category, isHindi: isHindi),
                CivicPriorityBadge(priority: g.priority),
                CivicStatusBadge(status: g.status, isHindi: isHindi),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              g.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${g.wardName} • Reported by ${g.citizenName}',
              style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            CivicSlaCountdownChip(
              slaDeadline: g.slaDeadline,
              isBreached: g.isSlaBreached,
              remaining: g.timeRemainingUntilSla,
            ),
            const Divider(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrievanceDetailScreen(
                          grievanceId: g.id,
                          state: widget.state,
                        ),
                      ),
                    );
                  },
                  child: const Text('View Full'),
                ),
                if (g.status == GrievanceStatus.submitted)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      widget.state.updateOfficerStatus(
                        grievanceId: g.id,
                        newStatus: GrievanceStatus.inProgress,
                        message: 'Dispatched maintenance truck and road repair crew.',
                      );
                    },
                    child: const Text('Dispatch'),
                  ),
                if (g.status == GrievanceStatus.inProgress || g.status == GrievanceStatus.reopened)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CivicColors.success,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      widget.state.updateOfficerStatus(
                        grievanceId: g.id,
                        newStatus: GrievanceStatus.resolved,
                        message: 'Repairs completed and inspected by ward engineer.',
                      );
                    },
                    child: const Text('Resolve'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
