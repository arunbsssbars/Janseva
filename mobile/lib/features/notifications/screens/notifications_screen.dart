import 'package:flutter/material.dart';
import '../../../core/models/civic_notification.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../tracking/screens/grievance_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final JanSevaState state;

  const NotificationsScreen({super.key, required this.state});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  CivicNotificationType? _selectedTypeFilter;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;

    final filtered = state.notifications.where((n) {
      if (_selectedTypeFilter != null && n.type != _selectedTypeFilter) return false;
      return true;
    }).toList();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'सूचनाएं एवं अलर्ट' : 'Notifications & Alerts',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (state.unreadNotificationsCount > 0)
            TextButton(
              onPressed: () => state.markAllNotificationsRead(),
              child: Text(
                isHindi ? 'सभी पढ़ें' : 'Mark all read',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Chips Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: CivicColors.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(isHindi ? 'सभी' : 'All'),
                    selected: _selectedTypeFilter == null,
                    onSelected: (_) => setState(() => _selectedTypeFilter = null),
                  ),
                  const SizedBox(width: 6),
                  ...CivicNotificationType.values.map((type) {
                    final isSelected = _selectedTypeFilter == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(isHindi ? type.titleHi : type.titleEn),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedTypeFilter = isSelected ? null : type),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: CivicColors.border),

          // Notification List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.notifications_none, size: 48, color: CivicColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            isHindi ? 'कोई नई सूचना नहीं है।' : 'No notifications found.',
                            style: const TextStyle(fontSize: 14, color: CivicColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notif = filtered[index];
                      return _buildNotificationCard(notif, isHindi);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(CivicNotification notif, bool isHindi) {
    final title = isHindi ? notif.titleHi : notif.title;
    final message = isHindi ? notif.messageHi : notif.message;
    final timeStr = _formatTimestamp(notif.timestamp, isHindi);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        widget.state.markNotificationRead(notif.id);

        if (notif.targetGrievanceId != null) {
          final target = widget.state.grievances.where((g) => g.id == notif.targetGrievanceId).firstOrNull;
          if (target != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GrievanceDetailScreen(
                  grievanceId: target.id,
                  state: widget.state,
                ),
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : Color(notif.type.colorHex).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: notif.isRead
                ? CivicColors.border
                : Color(notif.type.colorHex).withValues(alpha: 0.35),
            width: notif.isRead ? 1 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Type Badge + Time + Unread indicator
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(notif.type.colorHex).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isHindi ? notif.type.titleHi : notif.type.titleEn,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(notif.type.colorHex),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (!notif.isRead) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(notif.type.colorHex),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  timeStr,
                  style: const TextStyle(fontSize: 11, color: CivicColors.textMuted),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Notification Title
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                color: CivicColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Notification Message Body
            Text(
              message,
              style: const TextStyle(fontSize: 12, height: 1.35, color: CivicColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            if (notif.targetGrievanceId != null) ...[
              const SizedBox(height: 8),
              Text(
                isHindi ? 'शिकायत देखें →' : 'View Incident Details →',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CivicColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt, bool isHindi) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return isHindi ? '${diff.inMinutes} मि. पहले' : '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return isHindi ? '${diff.inHours} घंटे पहले' : '${diff.inHours}h ago';
    } else {
      return isHindi ? '${diff.inDays} दिन पहले' : '${diff.inDays}d ago';
    }
  }
}
