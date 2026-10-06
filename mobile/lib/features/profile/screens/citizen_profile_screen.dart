import 'package:flutter/material.dart';
import '../../../core/services/karma_calculator.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../feed/widgets/grievance_card.dart';
import '../../tracking/screens/grievance_detail_screen.dart';

class CitizenProfileScreen extends StatefulWidget {
  final JanSevaState state;

  const CitizenProfileScreen({super.key, required this.state});

  @override
  State<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  int _selectedActivityTab = 0; // 0: My Reports, 1: Upvoted Issues

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;
    final user = state.currentUser;

    final karma = CivicKarmaCalculator.computeKarma(
      user: user,
      allGrievances: state.grievances,
    );

    final myReports = state.grievances.where((g) => g.citizenId == user.id).toList();
    final upvotedReports = state.grievances.where((g) => g.upvotedUserIds.contains(user.id)).toList();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'नागरिक प्रोफ़ाइल एवं कर्म' : 'Citizen Profile & Karma',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CivicColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : 'U',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${user.locality} • ${user.phoneNumber}',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user.role.label,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Civic Karma Score Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
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
                            const Icon(Icons.stars, color: Colors.amber, size: 20),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isHindi ? 'विश्वास स्कोर' : 'Civic Trust Score',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(karma.tier.colorHex).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Color(karma.tier.colorHex).withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            isHindi ? karma.tier.titleHi : karma.tier.title,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(karma.tier.colorHex),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '${karma.score}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: CivicColors.primary,
                            ),
                            children: const [
                              TextSpan(
                                text: ' / 1000 pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: CivicColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: CivicColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Top ${karma.percentileRank.toStringAsFixed(0)}% in Ward',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: CivicColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (karma.score / 1000.0).clamp(0.0, 1.0),
                        backgroundColor: CivicColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(karma.tier.colorHex)),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHindi
                          ? 'सटीक शिकायतें दर्ज करने और समाधान सत्यापित करने से आपका विश्वास स्कोर बढ़ता है।'
                          : 'Points awarded for genuine verified issues, constructive feedback, and community upvotes.',
                      style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Metric Summary Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    title: isHindi ? 'दर्ज शिकायतें' : 'Filed Issues',
                    value: '${myReports.length}',
                    icon: Icons.assignment_outlined,
                    color: CivicColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    title: isHindi ? 'सत्यापित बंद' : 'Verified Closed',
                    value: '${karma.verifiedReportsCount}',
                    icon: Icons.check_circle_outline,
                    color: CivicColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    title: isHindi ? 'दिए गए अपवोट' : 'Upvoted',
                    value: '${upvotedReports.length}',
                    icon: Icons.thumb_up_alt_outlined,
                    color: CivicColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Activity Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedActivityTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedActivityTab == 0 ? CivicColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        '${isHindi ? "मेरी शिकायतें" : "My Complaints"} (${myReports.length})',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedActivityTab == 0 ? FontWeight.w800 : FontWeight.w500,
                          color: _selectedActivityTab == 0 ? CivicColors.primary : CivicColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedActivityTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedActivityTab == 1 ? CivicColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        '${isHindi ? "समर्थित मुद्दे" : "Upvoted"} (${upvotedReports.length})',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedActivityTab == 1 ? FontWeight.w800 : FontWeight.w500,
                          color: _selectedActivityTab == 1 ? CivicColors.primary : CivicColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Selected Activity Grievance List
            ...(_selectedActivityTab == 0 ? myReports : upvotedReports).map((g) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GrievanceCard(
                  grievance: g,
                  isHindi: isHindi,
                  hasUpvoted: g.upvotedUserIds.contains(user.id),
                  onUpvote: () => state.upvote(g.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrievanceDetailScreen(
                          grievanceId: g.id,
                          state: state,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            if ((_selectedActivityTab == 0 ? myReports : upvotedReports).isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    isHindi ? 'कोई शिकायत उपलब्ध नहीं है।' : 'No records found in this category.',
                    style: const TextStyle(fontSize: 13, color: CivicColors.textMuted),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
