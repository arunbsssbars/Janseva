import 'package:flutter/material.dart';
import '../enums/civic_enums.dart';
import '../theme/civic_colors.dart';

/// AQIL Defensive Component: Status Badge with color tint and icon
class CivicStatusBadge extends StatelessWidget {
  final GrievanceStatus status;
  final bool isHindi;

  const CivicStatusBadge({
    super.key,
    required this.status,
    this.isHindi = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case GrievanceStatus.submitted:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        icon = Icons.assignment_outlined;
        break;
      case GrievanceStatus.triaged:
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF6D28D9);
        icon = Icons.visibility_outlined;
        break;
      case GrievanceStatus.inProgress:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        icon = Icons.engineering_outlined;
        break;
      case GrievanceStatus.resolved:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF047857);
        icon = Icons.check_circle_outline;
        break;
      case GrievanceStatus.verifiedClosed:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1D4ED8);
        icon = Icons.verified_outlined;
        break;
      case GrievanceStatus.reopened:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        icon = Icons.replay;
        break;
    }

    final label = isHindi ? status.labelHi : status.labelEn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AQIL Defensive Component: Priority Indicator
class CivicPriorityBadge extends StatelessWidget {
  final GrievancePriority priority;

  const CivicPriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case GrievancePriority.low:
        color = CivicColors.priorityLow;
        break;
      case GrievancePriority.medium:
        color = CivicColors.priorityMedium;
        break;
      case GrievancePriority.high:
        color = CivicColors.priorityHigh;
        break;
      case GrievancePriority.emergency:
        color = CivicColors.priorityEmergency;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        priority.label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// AQIL Defensive Component: Category Badge with icon
class CivicCategoryChip extends StatelessWidget {
  final GrievanceCategory category;
  final bool isHindi;

  const CivicCategoryChip({
    super.key,
    required this.category,
    this.isHindi = false,
  });

  IconData _iconForCategory(String iconName) {
    switch (iconName) {
      case 'traffic':
        return Icons.traffic;
      case 'delete_outline':
        return Icons.delete_outline;
      case 'water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      case 'waves':
        return Icons.waves;
      case 'warning_amber_rounded':
        return Icons.warning_amber_rounded;
      case 'pets':
        return Icons.pets;
      case 'domain_disabled':
        return Icons.domain_disabled;
      default:
        return Icons.report_problem_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isHindi ? category.displayNameHi : category.displayNameEn;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CivicColors.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconForCategory(category.iconName),
            size: 14,
            color: CivicColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CivicColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AQIL Defensive Component: SLA Countdown Chip
class CivicSlaCountdownChip extends StatelessWidget {
  final DateTime slaDeadline;
  final bool isBreached;
  final Duration remaining;

  const CivicSlaCountdownChip({
    super.key,
    required this.slaDeadline,
    required this.isBreached,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isBreached ? CivicColors.error : CivicColors.textSecondary;
    final String text = isBreached
        ? 'SLA Breached'
        : remaining.inHours > 0
            ? '${remaining.inHours}h remaining'
            : '${remaining.inMinutes}m remaining';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isBreached ? CivicColors.errorContainer : CivicColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBreached ? Icons.timer_off_outlined : Icons.timer_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isBreached ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AQIL Defensive Component: Responsive Scaffold & Clamped Container
class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Widget? drawer;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor ?? CivicColors.background,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tablet/Desktop max constrained width
            if (constraints.maxWidth > 768) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 768),
                  child: body,
                ),
              );
            }
            return body;
          },
        ),
      ),
    );
  }
}
