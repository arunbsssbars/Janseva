import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/models/govt_channel.dart';
import '../../../core/models/grievance.dart';
import '../../../core/services/escalation_engine.dart';
import '../../../core/services/native_channel_launcher.dart';
import '../../../core/services/rti_petition_generator.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../verification/screens/resolution_audit_gate_screen.dart';

class GrievanceDetailScreen extends StatefulWidget {
  final String grievanceId;
  final JanSevaState state;

  const GrievanceDetailScreen({
    super.key,
    required this.grievanceId,
    required this.state,
  });

  @override
  State<GrievanceDetailScreen> createState() => _GrievanceDetailScreenState();
}

class _GrievanceDetailScreenState extends State<GrievanceDetailScreen> {
  void _showRtiPetitionModal(BuildContext context, Grievance grievance) {
    final draft = RtiPetitionGenerator.generateDraft(grievance: grievance);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: Color(0xFF1E3A8A), size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Statutory RTI Application (Sec 6(1))',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'RTI Act 2005 • 30-Day Mandatory Disclosure',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    draft.fullDraftText,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Legal Draft'),
                    onPressed: () {
                      NativeChannelLauncher.copyToClipboard(
                        ctx,
                        draft.fullDraftText,
                        successMessage: 'RTI Petition copied! Paste into rtionline.gov.in',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_browser, size: 18),
                    label: const Text('RTI Online Portal'),
                    onPressed: () {
                      NativeChannelLauncher.openOfficialPortal(GovtPortalType.cpgrams);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grievance = widget.state.grievances.firstWhere(
      (g) => g.id == widget.grievanceId,
      orElse: () => Grievance(
        id: widget.grievanceId,
        title: 'Not Found',
        description: '',
        category: GrievanceCategory.roadsAndPotholes,
        status: GrievanceStatus.submitted,
        priority: GrievancePriority.medium,
        wardId: 'W-01',
        wardName: '',
        latitude: 0,
        longitude: 0,
        address: '',
        landmark: '',
        citizenId: '',
        citizenName: '',
        citizenPhone: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        slaDeadline: DateTime.now(),
      ),
    );

    final isHindi = widget.state.isHindi;
    final isOfficer = widget.state.currentUser.isOfficer;
    final hasUpvoted = grievance.upvotedUserIds.contains(widget.state.currentUser.id);

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(grievance.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            tooltip: 'Share Dossier to WhatsApp',
            onPressed: () => NativeChannelLauncher.shareGrievanceDossier(grievance),
          ),
          IconButton(
            icon: Icon(
              hasUpvoted ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () => widget.state.upvote(grievance.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status and Category badges wrapped for AQIL responsiveness
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CivicCategoryChip(category: grievance.category, isHindi: isHindi),
                CivicPriorityBadge(priority: grievance.priority),
                CivicStatusBadge(status: grievance.status, isHindi: isHindi),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              grievance.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CivicColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Location
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CivicColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: CivicColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${grievance.wardName} • ${grievance.address}${grievance.landmark.isNotEmpty ? ' (Near ${grievance.landmark})' : ''}',
                      style: const TextStyle(fontSize: 13, color: CivicColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Description / विवरण',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: CivicColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              grievance.description,
              style: const TextStyle(fontSize: 14, height: 1.4, color: CivicColors.textPrimary),
            ),

            const SizedBox(height: 16),

            // SLA Tracking Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'SLA Resolution Target',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CivicSlaCountdownChip(
                          slaDeadline: grievance.slaDeadline,
                          isBreached: grievance.isSlaBreached,
                          remaining: grievance.timeRemainingUntilSla,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: grievance.slaProgressFraction,
                      backgroundColor: CivicColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        grievance.isSlaBreached ? CivicColors.error : CivicColors.primary,
                      ),
                      minHeight: 6,
                    ),
                    if (grievance.assignedOfficerName != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Assigned: ${grievance.assignedOfficerName}',
                        style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Builder(builder: (context) {
              final eval = CivicEscalationEngine.evaluate(grievance);
              if (eval.tier == EscalationTier.normal) return const SizedBox.shrink();

              final isHindi = widget.state.isHindi;
              return Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(eval.tier.badgeColorHex).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(eval.tier.badgeColorHex).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield_outlined, size: 16, color: Color(eval.tier.badgeColorHex)),
                              const SizedBox(width: 4),
                              Text(
                                isHindi ? eval.tier.titleHi : eval.tier.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(eval.tier.badgeColorHex),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Authority: ${isHindi ? eval.tier.authorityHi : eval.tier.authority}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isHindi ? eval.actionRequiredHi : eval.actionRequired,
                        style: const TextStyle(fontSize: 12, color: CivicColors.textPrimary, height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1B4B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.gavel_rounded, size: 16),
                        label: Text(
                          isHindi ? 'RTI धारा 6(1) कानूनी आवेदन तैयार करें' : 'Generate RTI Sec 6(1) Legal Petition',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showRtiPetitionModal(context, grievance),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Lifecycle Stepper Timeline
            const Text(
              'Resolution Progress / प्रगति विवरण',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._buildTimeline(grievance),

            const SizedBox(height: 20),

            // Citizen Verification Action Box (if Resolved)
            if (grievance.status == GrievanceStatus.resolved)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CivicColors.successContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CivicColors.success),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Action Required: Verify Resolution',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: CivicColors.success,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHindi
                          ? 'अधिकारी द्वारा कार्य पूरा किया गया है। कृपया मौके पर जाकर जांच करें।'
                          : 'Municipal team marked this issue resolved. Please inspect on ground.',
                      style: const TextStyle(fontSize: 13, color: CivicColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CivicColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.verified_user_rounded, size: 18),
                      label: Text(
                        isHindi ? 'एंटी-फ्रॉड समाधान ऑडिट गेट खोलें (+25 कर्मा)' : 'Open Anti-Fraud Resolution Audit Gate (+25 Karma)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ResolutionAuditGateScreen(
                              grievance: grievance,
                              state: widget.state,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: CivicColors.error,
                              side: const BorderSide(color: CivicColors.error),
                            ),
                            onPressed: () => _showFeedbackDialog(context, reopen: true),
                            child: const Text('Quick Reopen'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: CivicColors.success,
                              side: const BorderSide(color: CivicColors.success),
                            ),
                            onPressed: () => _showFeedbackDialog(context, reopen: false),
                            child: const Text('Quick Rate'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Officer Quick Action Box (if user is officer)
            if (isOfficer && grievance.status != GrievanceStatus.verifiedClosed)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CivicColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CivicColors.primary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ward Officer Actions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: CivicColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (grievance.status == GrievanceStatus.submitted)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.state.updateOfficerStatus(
                                  grievanceId: grievance.id,
                                  newStatus: GrievanceStatus.inProgress,
                                  message: 'Team assigned and on-site inspection initiated.',
                                );
                              },
                              child: const Text('Start Work'),
                            ),
                          ),
                        if (grievance.status == GrievanceStatus.inProgress ||
                            grievance.status == GrievanceStatus.reopened)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CivicColors.success,
                              ),
                              onPressed: () {
                                widget.state.updateOfficerStatus(
                                  grievanceId: grievance.id,
                                  newStatus: GrievanceStatus.resolved,
                                  message: 'Issue repaired and site cleared for citizen audit.',
                                );
                              },
                              child: const Text('Mark Resolved'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(Grievance grievance) {
    if (grievance.timeline.isEmpty) {
      return [
        const Text(
          'No timeline events recorded yet.',
          style: TextStyle(color: CivicColors.textMuted),
        ),
      ];
    }

    return grievance.timeline.map((event) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: CivicColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: CivicColors.border,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${event.actorName} (${event.actorRole})',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CivicStatusBadge(status: event.status, isHindi: widget.state.isHindi),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.message,
                    style: const TextStyle(fontSize: 13, color: CivicColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showFeedbackDialog(BuildContext context, {required bool reopen}) {
    int rating = 5;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(reopen ? 'Reopen Grievance' : 'Citizen Verification & Rating'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!reopen) ...[
                const Text('Rate resolution quality:'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final star = index + 1;
                    return IconButton(
                      icon: Icon(
                        star <= rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                      onPressed: () => setDialogState(() => rating = star),
                    );
                  }),
                ),
              ],
              TextField(
                controller: feedbackController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: reopen ? 'Reason for reopening *' : 'Feedback comment',
                  hintText: reopen
                      ? 'Why is the issue not resolved?'
                      : 'Share your feedback with the municipality',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.state.verifyResolution(
                  grievanceId: widget.grievanceId,
                  rating: rating,
                  feedback: feedbackController.text.trim().isEmpty
                      ? (reopen ? 'Reopened by citizen' : 'Resolution verified')
                      : feedbackController.text.trim(),
                  reopen: reopen,
                );
                Navigator.pop(dialogCtx);
              },
              child: Text(reopen ? 'Confirm Reopen' : 'Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
