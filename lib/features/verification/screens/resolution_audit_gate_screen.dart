import 'package:flutter/material.dart';
import '../../../core/models/grievance.dart';
import '../../../core/services/native_channel_launcher.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';

class ResolutionAuditGateScreen extends StatefulWidget {
  final Grievance grievance;
  final JanSevaState state;

  const ResolutionAuditGateScreen({
    super.key,
    required this.grievance,
    required this.state,
  });

  @override
  State<ResolutionAuditGateScreen> createState() => _ResolutionAuditGateScreenState();
}

class _ResolutionAuditGateScreenState extends State<ResolutionAuditGateScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmResolution() async {
    setState(() => _isSubmitting = true);
    await widget.state.verifyAndRateGrievance(
      grievanceId: widget.grievance.id,
      rating: 5,
      feedback: _feedbackController.text.trim().isNotEmpty
          ? _feedbackController.text.trim()
          : 'Work verified on ground. Complete resolution confirmed.',
      reopen: false,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resolution Verified! +25 Citizen Karma Points awarded.'),
          backgroundColor: CivicColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handleRejectResolution() async {
    final reason = _feedbackController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please state why the work was not completed properly.'),
          backgroundColor: CivicColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await widget.state.verifyAndRateGrievance(
      grievanceId: widget.grievance.id,
      rating: 1,
      feedback: 'REJECTED: $reason',
      reopen: true,
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.gavel_rounded, color: CivicColors.error),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Escalated to Vigilance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          content: Text(
            'Docket #${widget.grievance.govtDocketNumber ?? widget.grievance.id} was re-opened and flagged for FALSE COMPLIANCE AUDIT by the Municipal Commissioner Vigilance Cell.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                NativeChannelLauncher.shareGrievanceDossier(widget.grievance);
              },
              child: const Text('Share to Ward WhatsApp'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: CivicColors.error),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.grievance;
    final isHindi = widget.state.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'कार्य समाधान सत्यापन' : 'Resolution Audit Gate',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning header card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFFB45309), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'नागरिक सत्यापन आवश्यक' : 'Mandatory Citizen Sign-off',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHindi
                              ? 'ठेकेदार/विभाग का दावा है कि कार्य पूरा हो चुका है। कृपया जांचें।'
                              : 'Department claims this issue is resolved. Verify on the ground before closing.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Docket summary
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          g.govtDocketNumber ?? g.id,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: CivicColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g.category.displayNameEn,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: CivicColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      g.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.address,
                      style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Before vs After Proof Cards
            Text(
              isHindi ? 'कार्य तुलना (पहले बनाम बाद में)' : 'Inspection Proof Comparison',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.report_problem, size: 16, color: Colors.deepOrange),
                            SizedBox(width: 4),
                            Text('ORIGINAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.photo_camera_back, size: 36, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          g.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: CivicColors.success),
                            SizedBox(width: 4),
                            Text('CLAIMED WORK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CivicColors.success)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.verified, size: 36, color: CivicColors.success),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          g.resolutionNotes ?? 'Officer closed with completed mark.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Citizen notes input
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isHindi ? 'नागरिक ग्राउंड रिपोर्ट / टिप्पणी' : 'Citizen Ground Verification Notes',
                hintText: isHindi
                    ? 'यदि कार्य अधूरा है, तो कारण लिखें (जैसे: केवल मिट्टी डाली है, डामर नहीं)...'
                    : 'If unsatisfied, describe why (e.g. debris left behind, water still leaking)...',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CivicColors.success,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.thumb_up_alt_rounded),
                    label: Text(
                      isHindi ? 'सत्यापित: कार्य पूर्ण हो गया है (+25 Karma)' : 'VERIFIED: WORK IS COMPLETE (+25 Karma)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _handleConfirmResolution,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CivicColors.error,
                      side: const BorderSide(color: CivicColors.error, width: 1.5),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.gavel_rounded),
                    label: Text(
                      isHindi ? 'अस्वीकार करें: काम नहीं हुआ (सतर्कता शिकायत)' : 'REJECT: NOT FIXED (ESCALATE TO VIGILANCE)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _handleRejectResolution,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
