import 'package:flutter/material.dart';
import '../../../core/services/analytics_engine.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class CivicAnalyticsScreen extends StatelessWidget {
  final JanSevaState state;

  const CivicAnalyticsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isHindi = state.isHindi;
    final data = CivicAnalyticsEngine.computeAnalytics(
      grievances: state.grievances,
      wards: state.wards,
    );

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'नागरिक विश्लेषण एवं रिपोर्ट' : 'Civic Performance Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header summary
            Text(
              isHindi ? 'नगरपालिका कार्यकुशलता स्कोरकार्ड' : 'Municipal Efficiency Scorecard',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              isHindi
                  ? 'शहर के विभिन्न वार्डों में नागरिक शिकायतों का वास्तविक समय डेटा।'
                  : 'Real-time transparent telemetry across all municipal wards and departments.',
              style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
            ),

            const SizedBox(height: 16),

            // Top KPI row
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Total Reports',
                    value: '${data.totalGrievances}',
                    color: CivicColors.primary,
                    icon: Icons.list_alt,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Resolved',
                    value: '${data.resolvedGrievances}',
                    color: CivicColors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Avg TAT',
                    value: '${data.averageResolutionHours.toStringAsFixed(1)}h',
                    color: CivicColors.warning,
                    icon: Icons.speed,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // SLA Compliance Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'SLA Compliance Benchmark',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${data.slaComplianceRate.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: data.slaComplianceRate >= 80 ? CivicColors.success : CivicColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: data.slaComplianceRate / 100.0,
                        backgroundColor: CivicColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          data.slaComplianceRate >= 80 ? CivicColors.success : CivicColors.warning,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${data.breachedGrievances} out of ${data.totalGrievances} grievances breached municipal SLA.',
                      style: const TextStyle(fontSize: 12, color: CivicColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category Breakdown Section
            Text(
              isHindi ? 'समस्या श्रेणी वितरण' : 'Grievance Breakdown by Category',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...data.categoryCounts.entries.where((e) => e.value > 0).map((entry) {
              final cat = entry.key;
              final count = entry.value;
              final pct = data.totalGrievances > 0 ? (count / data.totalGrievances) : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        isHindi ? cat.displayNameHi : cat.displayNameEn,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: CivicColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(CivicColors.primaryLight),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$count',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Ward Performance Leaderboard
            Text(
              isHindi ? 'वार्ड प्रदर्शन तालिका' : 'Ward Performance Leaderboard',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.wardRankings.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = data.wardRankings[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey.shade400
                                  : index == 2
                                      ? Colors.brown.shade300
                                      : CivicColors.surfaceVariant,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ward ${item.ward.wardNumber}: ${item.ward.wardName}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${item.resolvedCount}/${item.totalCount} resolved • ${item.ward.officerName}',
                                style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.resolutionRate.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: item.resolutionRate >= 75 ? CivicColors.success : CivicColors.warning,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
