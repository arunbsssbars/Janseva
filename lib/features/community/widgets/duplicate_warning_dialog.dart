import 'package:flutter/material.dart';
import '../../../core/services/duplicate_detector.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class DuplicateWarningDialog extends StatelessWidget {
  final List<DuplicateMatchResult> matches;
  final bool isHindi;
  final Function(String existingGrievanceId) onUpvoteExisting;
  final VoidCallback onProceedAnyway;

  const DuplicateWarningDialog({
    super.key,
    required this.matches,
    required this.isHindi,
    required this.onUpvoteExisting,
    required this.onProceedAnyway,
  });

  @override
  Widget build(BuildContext context) {
    final topMatch = matches.first;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: CivicColors.warning, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isHindi ? 'समान शिकायत पहले से मौजूद है' : 'Similar Issue Already Reported',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi
                  ? 'आपके पड़ोस में एक मिलती-जुलती शिकायत पहले से सक्रिय है। नई शिकायत दर्ज करने के बजाय इसे अपवोट करें ताकि नगरपालिका इसे उच्च प्राथमिकता दे सके।'
                  : 'An active report was found in this ward matching your description. Upvoting it raises urgency and avoids duplicate tickets for the field engineers.',
              style: const TextStyle(fontSize: 13, color: CivicColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CivicColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CivicColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CivicStatusBadge(
                        status: topMatch.existingGrievance.status,
                        isHindi: isHindi,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${(topMatch.similarityScore * 100).toInt()}% Match',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: CivicColors.warning,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    topMatch.existingGrievance.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${topMatch.existingGrievance.wardName} • ${topMatch.existingGrievance.address}',
                    style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Current Upvotes: ${topMatch.existingGrievance.upvoteCount}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CivicColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onProceedAnyway,
          child: Text(
            isHindi ? 'फिर भी नई शिकायत दर्ज करें' : 'Proceed Anyway',
            style: const TextStyle(color: CivicColors.textSecondary),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: CivicColors.primary),
          onPressed: () => onUpvoteExisting(topMatch.existingGrievance.id),
          icon: const Icon(Icons.thumb_up, size: 16),
          label: Text(
            isHindi ? 'मौजूदा शिकायत को अपवोट करें' : 'Upvote Existing',
          ),
        ),
      ],
    );
  }
}
