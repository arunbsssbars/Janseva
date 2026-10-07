import 'package:flutter/material.dart';
import '../../../core/models/grievance.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class GrievanceCard extends StatelessWidget {
  final Grievance grievance;
  final bool isHindi;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final bool hasUpvoted;

  const GrievanceCard({
    super.key,
    required this.grievance,
    required this.isHindi,
    required this.onTap,
    required this.onUpvote,
    required this.hasUpvoted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: CivicColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Category chip & Status badge (Defensive Wrap)
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  CivicCategoryChip(
                    category: grievance.category,
                    isHindi: isHindi,
                  ),
                  if (grievance.govtDocketNumber != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        grievance.govtDocketNumber!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  CivicStatusBadge(
                    status: grievance.status,
                    isHindi: isHindi,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Title with ellipsis defense
              Text(
                grievance.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: CivicColors.textPrimary,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 6),

              // Location and Ward metadata (Single text joined with bullet)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: CivicColors.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${grievance.wardName} • ${grievance.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CivicColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Bottom Row: SLA timer badge & Upvote interaction (Defensive Wrap)
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  CivicSlaCountdownChip(
                    slaDeadline: grievance.slaDeadline,
                    isBreached: grievance.isSlaBreached,
                    remaining: grievance.timeRemainingUntilSla,
                  ),
                  // Upvote button
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onUpvote,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: hasUpvoted
                            ? CivicColors.primaryContainer
                            : CivicColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasUpvoted ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            size: 14,
                            color: hasUpvoted ? CivicColors.primary : CivicColors.textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${grievance.upvoteCount}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: hasUpvoted ? CivicColors.primary : CivicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
