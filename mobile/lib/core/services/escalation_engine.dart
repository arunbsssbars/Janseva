import '../enums/civic_enums.dart';
import '../models/grievance.dart';

enum EscalationTier {
  normal(
    level: 0,
    title: 'Standard Track',
    titleHi: 'मानक ट्रैक',
    authority: 'Ward Junior Engineer',
    authorityHi: 'वार्ड कनिष्ठ अभियंता',
    badgeColorHex: 0xFF64748B,
  ),
  warning(
    level: 1,
    title: 'SLA Warning (75%)',
    titleHi: 'चेतावनी (75% समय व्यतीत)',
    authority: 'Ward Field Officer',
    authorityHi: 'वार्ड क्षेत्रीय अधिकारी',
    badgeColorHex: 0xFFF59E0B,
  ),
  tier1Breach(
    level: 2,
    title: 'Tier-1 SLA Breached',
    titleHi: 'स्तर-1 उल्लंघन (अधीक्षक)',
    authority: 'Zonal Executive Engineer',
    authorityHi: 'क्षेत्रीय अधिशासी अभियंता',
    badgeColorHex: 0xFFEA580C,
  ),
  criticalBreach(
    level: 3,
    title: 'Tier-2 Critical Breach',
    titleHi: 'स्तर-2 अति-गंभीर उल्लंघन (आयुक्त)',
    authority: 'Municipal Commissioner Cell',
    authorityHi: 'नगर निगम आयुक्त प्रकोष्ठ',
    badgeColorHex: 0xFFDC2626,
  );

  const EscalationTier({
    required this.level,
    required this.title,
    required this.titleHi,
    required this.authority,
    required this.authorityHi,
    required this.badgeColorHex,
  });

  final int level;
  final String title;
  final String titleHi;
  final String authority;
  final String authorityHi;
  final int badgeColorHex;
}

class EscalationEvaluation {
  final EscalationTier tier;
  final double elapsedPercentage;
  final Duration overdueDuration;
  final String actionRequired;
  final String actionRequiredHi;

  const EscalationEvaluation({
    required this.tier,
    required this.elapsedPercentage,
    required this.overdueDuration,
    required this.actionRequired,
    required this.actionRequiredHi,
  });

  String get authority => tier.authority;
  String get authorityHi => tier.authorityHi;
}

class CivicEscalationEngine {
  /// Evaluates the grievance SLA progress and determines the escalation tier.
  static EscalationEvaluation evaluate(Grievance grievance, {DateTime? currentTime}) {
    final now = currentTime ?? DateTime.now();

    // If resolved or closed, it stays at normal tier
    if (grievance.status == GrievanceStatus.resolved ||
        grievance.status == GrievanceStatus.verifiedClosed) {
      return const EscalationEvaluation(
        tier: EscalationTier.normal,
        elapsedPercentage: 100.0,
        overdueDuration: Duration.zero,
        actionRequired: 'Grievance resolved. No escalation required.',
        actionRequiredHi: 'शिकायत का समाधान हो चुका है। कोई कार्रवाई आवश्यक नहीं।',
      );
    }

    final totalDuration = grievance.slaDeadline.difference(grievance.createdAt);
    final elapsedDuration = now.difference(grievance.createdAt);

    if (totalDuration.inSeconds <= 0) {
      return const EscalationEvaluation(
        tier: EscalationTier.normal,
        elapsedPercentage: 0.0,
        overdueDuration: Duration.zero,
        actionRequired: 'Pending initial dispatch.',
        actionRequiredHi: 'प्रारंभिक प्रेषण लंबित है।',
      );
    }

    final ratio = elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;

    if (ratio >= 1.5) {
      final overdue = now.difference(grievance.slaDeadline);
      return EscalationEvaluation(
        tier: EscalationTier.criticalBreach,
        elapsedPercentage: ratio * 100,
        overdueDuration: overdue,
        actionRequired: 'Automated summon issued to Municipal Commissioner Cell with daily compliance penalty.',
        actionRequiredHi: 'नगर निगम आयुक्त प्रकोष्ठ को दैनिक जुर्माना नोटिस जारी।',
      );
    } else if (ratio >= 1.0) {
      final overdue = now.difference(grievance.slaDeadline);
      return EscalationEvaluation(
        tier: EscalationTier.tier1Breach,
        elapsedPercentage: ratio * 100,
        overdueDuration: overdue,
        actionRequired: 'Re-routed to Zonal Executive Engineer for mandatory fast-track clearance.',
        actionRequiredHi: 'त्वरित समाधान हेतु क्षेत्रीय अधिशासी अभियंता को पुनः प्रेषित।',
      );
    } else if (ratio >= 0.75) {
      return EscalationEvaluation(
        tier: EscalationTier.warning,
        elapsedPercentage: ratio * 100,
        overdueDuration: Duration.zero,
        actionRequired: 'Automated SMS & in-app reminder dispatched to Ward Field Officer.',
        actionRequiredHi: 'वार्ड क्षेत्रीय अधिकारी को स्वचालित एसएमएस व ऐप चेतावनी प्रेषित।',
      );
    } else {
      return EscalationEvaluation(
        tier: EscalationTier.normal,
        elapsedPercentage: ratio * 100,
        overdueDuration: Duration.zero,
        actionRequired: 'Under normal SLA execution cycle.',
        actionRequiredHi: 'मानक एसएलए अवधि के अंतर्गत प्रगति पर।',
      );
    }
  }

  /// Categorizes a list of grievances by their active escalation tier
  static Map<EscalationTier, List<Grievance>> categorizeByEscalation(List<Grievance> grievances, {DateTime? currentTime}) {
    final Map<EscalationTier, List<Grievance>> result = {
      EscalationTier.normal: [],
      EscalationTier.warning: [],
      EscalationTier.tier1Breach: [],
      EscalationTier.criticalBreach: [],
    };

    for (final g in grievances) {
      final eval = evaluate(g, currentTime: currentTime);
      result[eval.tier]?.add(g);
    }

    return result;
  }
}
