import 'package:flutter/material.dart';

class CsatBreakdownCard extends StatelessWidget {
  final int speedRating;
  final int qualityRating;
  final int behaviorRating;
  final bool wouldRecommend;
  final ValueChanged<int> onSpeedChanged;
  final ValueChanged<int> onQualityChanged;
  final ValueChanged<int> onBehaviorChanged;
  final ValueChanged<bool> onRecommendChanged;
  final bool isHindi;

  const CsatBreakdownCard({
    super.key,
    required this.speedRating,
    required this.qualityRating,
    required this.behaviorRating,
    required this.wouldRecommend,
    required this.onSpeedChanged,
    required this.onQualityChanged,
    required this.onBehaviorChanged,
    required this.onRecommendChanged,
    this.isHindi = false,
  });

  Widget _buildRatingRow({
    required BuildContext context,
    required String label,
    required int currentRating,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final star = index + 1;
              return GestureDetector(
                onTap: () => onChanged(star),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    star <= currentRating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 22,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, size: 16, color: Color(0xFF1E3A8A)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isHindi ? 'विस्तृत संतुष्टि मूल्यांकन (CSAT)' : 'Detailed Resolution CSAT Scorecard',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildRatingRow(
            context: context,
            label: isHindi ? 'समाधान की गति' : 'Resolution Speed',
            currentRating: speedRating,
            onChanged: onSpeedChanged,
          ),
          _buildRatingRow(
            context: context,
            label: isHindi ? 'कार्य की गुणवत्ता' : 'Workmanship & Quality',
            currentRating: qualityRating,
            onChanged: onQualityChanged,
          ),
          _buildRatingRow(
            context: context,
            label: isHindi ? 'अधिकारी का व्यवहार' : 'Officer Courtesy',
            currentRating: behaviorRating,
            onChanged: onBehaviorChanged,
          ),
          const Divider(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  isHindi ? 'क्या आप पड़ोसियों को सुझाव देंगे?' : 'Recommend service delivery?',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChoiceChip(
                    label: Text(
                      isHindi ? 'हाँ' : 'Yes',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: wouldRecommend ? FontWeight.bold : FontWeight.normal,
                        color: wouldRecommend ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                    selected: wouldRecommend,
                    selectedColor: const Color(0xFF10B981),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onSelected: (val) {
                      if (val) onRecommendChanged(true);
                    },
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text(
                      isHindi ? 'नहीं' : 'No',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: !wouldRecommend ? FontWeight.bold : FontWeight.normal,
                        color: !wouldRecommend ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                    selected: !wouldRecommend,
                    selectedColor: const Color(0xFFEF4444),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onSelected: (val) {
                      if (val) onRecommendChanged(false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
