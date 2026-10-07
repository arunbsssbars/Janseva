import 'package:flutter/material.dart';
import '../../../core/models/grievance.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../widgets/csat_breakdown_card.dart';

class CitizenVerificationScreen extends StatefulWidget {
  final Grievance grievance;
  final JanSevaState state;

  const CitizenVerificationScreen({
    super.key,
    required this.grievance,
    required this.state,
  });

  @override
  State<CitizenVerificationScreen> createState() => _CitizenVerificationScreenState();
}

class _CitizenVerificationScreenState extends State<CitizenVerificationScreen> {
  int _selectedRating = 5;
  int _speedRating = 5;
  int _qualityRating = 5;
  int _behaviorRating = 5;
  bool _wouldRecommend = true;
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitVerification({required bool reopen}) async {
    final feedback = _feedbackController.text.trim();
    if (reopen && feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: CivicColors.error,
          content: Text('Please explain why the resolution is unsatisfactory to reopen.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.state.verifyResolution(
        grievanceId: widget.grievance.id,
        rating: _selectedRating,
        feedback: feedback.isEmpty
            ? (reopen ? 'Reopened by citizen' : 'Resolution verified by citizen.')
            : feedback,
        reopen: reopen,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: reopen ? CivicColors.warning : CivicColors.success,
            content: Text(
              reopen
                  ? 'Grievance reopened and escalated to senior department head.'
                  : 'Thank you! Grievance verified and closed.',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.state.isHindi;
    final g = widget.grievance;

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'नागरिक सत्यापन' : 'Citizen Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grievance summary header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            g.id,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: CivicColors.textMuted,
                            ),
                          ),
                        ),
                        CivicStatusBadge(status: g.status, isHindi: isHindi),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      g.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${g.wardName} • ${g.address}',
                      style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Before vs After Photo Proof Comparison
            Text(
              isHindi ? 'कार्य पूर्व एवं कार्य पश्चात साक्ष्य' : 'Resolution Proof (Before vs After)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: CivicColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CivicColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image_outlined, size: 32, color: CivicColors.textMuted),
                        const SizedBox(height: 4),
                        Text(
                          isHindi ? 'शिकायत समय (पूर्व)' : 'Reported (Before)',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: CivicColors.successContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CivicColors.success.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 32, color: CivicColors.success),
                        const SizedBox(height: 4),
                        Text(
                          isHindi ? 'कार्य पश्चात (अधिकारी)' : 'Resolved (After)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: CivicColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Officer Remarks Box
            if (g.resolutionNotes != null && g.resolutionNotes!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CivicColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Officer Notes (${g.assignedOfficerName ?? "Ward Officer"}):',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.resolutionNotes!,
                      style: const TextStyle(fontSize: 13, color: CivicColors.textPrimary),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Rating Stars
            Center(
              child: Column(
                children: [
                  Text(
                    isHindi ? 'कार्य की गुणवत्ता का मूल्यांकन करें' : 'Rate Resolution Quality',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return IconButton(
                        iconSize: 36,
                        icon: Icon(
                          star <= _selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => _selectedRating = star),
                      );
                    }),
                  ),
                  Text(
                    _getRatingLabel(_selectedRating),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CivicColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detailed CSAT Breakdown Card
            CsatBreakdownCard(
              speedRating: _speedRating,
              qualityRating: _qualityRating,
              behaviorRating: _behaviorRating,
              wouldRecommend: _wouldRecommend,
              isHindi: isHindi,
              onSpeedChanged: (r) => setState(() => _speedRating = r),
              onQualityChanged: (r) => setState(() => _qualityRating = r),
              onBehaviorChanged: (r) => setState(() => _behaviorRating = r),
              onRecommendChanged: (w) => setState(() => _wouldRecommend = w),
            ),

            const SizedBox(height: 16),

            // Comments
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isHindi ? 'नागरिक टिप्पणी / प्रतिक्रिया' : 'Citizen Comments & Feedback',
                hintText: isHindi
                    ? 'कृपया अपने अनुभव या कोई लंबित कमी साझा करें...'
                    : 'Share details of the resolution quality or issues...',
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CivicColors.error,
                      side: const BorderSide(color: CivicColors.error, width: 1.5),
                    ),
                    onPressed: _isSubmitting ? null : () => _submitVerification(reopen: true),
                    child: Text(isHindi ? 'असंतोषजनक (पुनः खोलें)' : 'Unsatisfactory (Reopen)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CivicColors.success,
                    ),
                    onPressed: _isSubmitting ? null : () => _submitVerification(reopen: false),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(isHindi ? 'सत्यापित करें और बंद करें' : 'Verify & Close'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 5:
        return 'Excellent Resolution ★★★★★';
      case 4:
        return 'Good Work ★★★★☆';
      case 3:
        return 'Average Resolution ★★★☆☆';
      case 2:
        return 'Below Expectations ★★☆☆☆';
      case 1:
        return 'Very Poor Resolution ★☆☆☆☆';
      default:
        return '';
    }
  }
}
