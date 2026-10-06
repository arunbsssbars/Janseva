import 'package:flutter/material.dart';
import 'core/enums/civic_enums.dart';
import 'core/localization/civic_strings.dart';
import 'core/models/grievance.dart';
import 'core/state/janseva_state.dart';
import 'core/theme/civic_colors.dart';
import 'core/theme/civic_theme.dart';
import 'core/widgets/civic_widgets.dart';
import 'features/analytics/screens/civic_analytics_screen.dart';
import 'features/emergency/screens/emergency_hub_screen.dart';
import 'features/feed/widgets/grievance_card.dart';
import 'features/forum/screens/ward_forum_screen.dart';
import 'features/map/screens/ward_map_screen.dart';
import 'features/notices/screens/ward_notices_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'features/officer/screens/officer_dashboard_screen.dart';
import 'features/profile/screens/citizen_profile_screen.dart';
import 'features/public_works/screens/public_works_screen.dart';
import 'features/reporting/screens/report_grievance_screen.dart';
import 'features/schemes/screens/schemes_directory_screen.dart';
import 'features/tracking/screens/grievance_detail_screen.dart';
import 'features/verification/screens/verification_screen.dart';
import 'features/rti/screens/rti_portal_screen.dart';
import 'features/officer/screens/inspection_route_screen.dart';
import 'features/community/screens/civic_drives_screen.dart';
import 'features/billing/screens/utility_dispute_screen.dart';
import 'features/profile/screens/identity_verification_screen.dart';
import 'features/veterinary/screens/animal_rescue_screen.dart';
import 'features/climate/screens/heat_resilience_screen.dart';
import 'features/budget/screens/participatory_budget_screen.dart';
import 'features/vending/screens/street_vendor_screen.dart';
import 'features/telemetry/screens/iot_telemetry_screen.dart';
import 'features/disaster/screens/flood_preparedness_screen.dart';
import 'core/services/karma_calculator.dart';

void main() {
  runApp(const JanSevaApp());
}

class JanSevaApp extends StatefulWidget {
  final JanSevaState? initialState;
  const JanSevaApp({super.key, this.initialState});

  @override
  State<JanSevaApp> createState() => _JanSevaAppState();
}

class _JanSevaAppState extends State<JanSevaApp> {
  late final JanSevaState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState ?? JanSevaState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) {
        return MaterialApp(
          title: _state.isHindi ? 'जनसेवा' : 'JanSeva',
          debugShowCheckedModeBanner: false,
          theme: CivicTheme.lightTheme,
          home: JanSevaHomeScreen(state: _state),
        );
      },
    );
  }
}

class JanSevaHomeScreen extends StatefulWidget {
  final JanSevaState state;

  const JanSevaHomeScreen({super.key, required this.state});

  @override
  State<JanSevaHomeScreen> createState() => _JanSevaHomeScreenState();
}

class _JanSevaHomeScreenState extends State<JanSevaHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;

    // If user is currently switched into Ward Officer mode, show Officer Workspace
    if (state.currentUser.isOfficer && _currentIndex == 0) {
      return OfficerDashboardScreen(state: state);
    }

    final List<Widget> pages = [
      _buildGrievancesFeed(state, isHindi),
      CivicAnalyticsScreen(state: state),
      EmergencyHubScreen(state: state),
      SchemesDirectoryScreen(state: state),
      WardNoticesScreen(state: state),
    ];

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi ? 'जनसेवा' : 'JanSeva',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              isHindi ? 'नागरिक सेवा पोर्टल' : 'Citizen Grievance Portal',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // Offline / Online toggle for field testing
          IconButton(
            tooltip: state.isOnline ? 'Online Mode' : 'Offline Mode (Queued)',
            icon: Icon(
              state.isOnline ? Icons.wifi : Icons.wifi_off,
              color: state.isOnline ? Colors.white : Colors.amber,
              size: 20,
            ),
            onPressed: () {
              state.toggleOnlineStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.isOnline
                        ? 'Connected to Municipal Gateway.'
                        : 'Offline Mode: Reports will be safely stored on device.',
                  ),
                ),
              );
            },
          ),

          // Bilingual Language Switcher
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onPressed: () => state.toggleLanguage(),
            child: Text(
              CivicStrings.get('languageToggle', isHindi: isHindi),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),

          // In-App Notification Center
          IconButton(
            key: const Key('app_notifications_btn'),
            tooltip: 'Notifications',
            icon: Badge(
              isLabelVisible: state.unreadNotificationsCount > 0,
              label: Text('${state.unreadNotificationsCount}'),
              child: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationsScreen(state: state),
                ),
              );
            },
          ),

          // Role Switcher (Citizen <-> Officer)
          PopupMenuButton<UserRole>(
            tooltip: 'Switch Portal Mode',
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onSelected: (role) => state.switchRole(role),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: UserRole.citizen,
                child: Text('Citizen Mode (${state.currentUser.name})'),
              ),
              const PopupMenuItem(
                value: UserRole.wardOfficer,
                child: Text('Ward Officer Workspace'),
              ),
            ],
          ),
        ],
      ),
      drawer: _buildAppDrawer(context, state),
      body: pages[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: CivicColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(
                isHindi ? 'शिकायत दर्ज करें' : 'Report Issue',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportGrievanceScreen(state: state),
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.feed_outlined),
            selectedIcon: const Icon(Icons.feed),
            label: isHindi ? 'शिकायतें' : 'Grievances',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: isHindi ? 'विश्लेषण' : 'Analytics',
          ),
          NavigationDestination(
            icon: const Icon(Icons.emergency_outlined),
            selectedIcon: const Icon(Icons.emergency),
            label: isHindi ? 'आपातकाल' : 'SOS 112',
          ),
          NavigationDestination(
            icon: const Icon(Icons.assured_workload_outlined),
            selectedIcon: const Icon(Icons.assured_workload),
            label: isHindi ? 'योजनाएं' : 'Schemes',
          ),
          NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            selectedIcon: const Icon(Icons.campaign),
            label: isHindi ? 'सूचनाएं' : 'Notices',
          ),
        ],
      ),
    );
  }

  Widget _buildGrievancesFeed(JanSevaState state, bool isHindi) {
    final grievances = state.grievances;

    return RefreshIndicator(
      onRefresh: () => state.refreshGrievances(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Offline Banner with sync button if reports pending
          if (state.offlinePendingCount > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: CivicColors.warningContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CivicColors.warning.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: CivicColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${state.offlinePendingCount} report(s) queued offline.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CivicColors.warning,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final count = await state.syncOfflineReports();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Synced $count pending report(s) to gateway!')),
                        );
                      }
                    },
                    child: Text(isHindi ? 'सिंक करें' : 'Sync Now'),
                  ),
                ],
              ),
            ),

          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: isHindi ? 'शिकायत, क्षेत्र या आईडी खोजें...' : 'Search grievance, locality...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        state.setSearchQuery('');
                      },
                    )
                  : null,
            ),
            onChanged: (val) => state.setSearchQuery(val),
          ),

          const SizedBox(height: 12),

          // Ward and Category Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Status Filter Chips
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      isHindi ? 'सभी' : 'All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: state.selectedStatus == null ? FontWeight.w700 : FontWeight.w500,
                        color: state.selectedStatus == null ? Colors.white : CivicColors.textPrimary,
                      ),
                    ),
                    selected: state.selectedStatus == null,
                    selectedColor: CivicColors.primary,
                    onSelected: (_) => state.setFilterStatus(null),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      isHindi ? 'समीक्षाधीन' : 'Under Review',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: state.selectedStatus == GrievanceStatus.triaged ? FontWeight.w700 : FontWeight.w500,
                        color: state.selectedStatus == GrievanceStatus.triaged ? Colors.white : CivicColors.textPrimary,
                      ),
                    ),
                    selected: state.selectedStatus == GrievanceStatus.triaged,
                    selectedColor: CivicColors.primary,
                    onSelected: (_) => state.setFilterStatus(GrievanceStatus.triaged),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      isHindi ? 'प्रगति पर' : 'In Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: state.selectedStatus == GrievanceStatus.inProgress ? FontWeight.w700 : FontWeight.w500,
                        color: state.selectedStatus == GrievanceStatus.inProgress ? Colors.white : CivicColors.textPrimary,
                      ),
                    ),
                    selected: state.selectedStatus == GrievanceStatus.inProgress,
                    selectedColor: CivicColors.primary,
                    onSelected: (_) => state.setFilterStatus(GrievanceStatus.inProgress),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      isHindi ? 'निस्तारित' : 'Resolved',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: state.selectedStatus == GrievanceStatus.resolved ? FontWeight.w700 : FontWeight.w500,
                        color: state.selectedStatus == GrievanceStatus.resolved ? Colors.white : CivicColors.textPrimary,
                      ),
                    ),
                    selected: state.selectedStatus == GrievanceStatus.resolved,
                    selectedColor: CivicColors.primary,
                    onSelected: (_) => state.setFilterStatus(GrievanceStatus.resolved),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action Required Banner for Citizen Verification
          ...grievances
              .where((g) => g.status == GrievanceStatus.resolved)
              .map((g) => _buildVerificationBanner(g, state, isHindi)),

          // Grievance Feed List
          ...grievances.map((g) {
            final hasUpvoted = g.upvotedUserIds.contains(state.currentUser.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GrievanceCard(
                grievance: g,
                isHindi: isHindi,
                hasUpvoted: hasUpvoted,
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

          if (grievances.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.inbox, size: 48, color: CivicColors.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      isHindi ? 'कोई शिकायत नहीं मिली' : 'No grievances found',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner(Grievance g, JanSevaState state, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CivicColors.successContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CivicColors.success.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: CivicColors.success, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'कार्रवाई अपेक्षित: कार्य सत्यापित करें' : 'Verify Resolution: ${g.id}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: CivicColors.success),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  g.title,
                  style: const TextStyle(fontSize: 12, color: CivicColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CivicColors.success,
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CitizenVerificationScreen(
                    grievance: g,
                    state: state,
                  ),
                ),
              );
            },
            child: Text(isHindi ? 'जांचें' : 'Verify'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context, JanSevaState state) {
    final karma = CivicKarmaCalculator.computeKarma(
      user: state.currentUser,
      allGrievances: state.grievances,
    );
    final isHindi = state.isHindi;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              state.currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${state.currentUser.phoneNumber} • ${state.currentUser.locality}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${karma.tier.title} (${karma.score} pts)',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                state.currentUser.name.isNotEmpty
                    ? state.currentUser.name.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
            title: Text(isHindi ? 'नागरिक प्रोफाइल व ट्रस्ट स्कोर' : 'Citizen Profile & Karma'),
            subtitle: Text('${karma.score} karma points'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CitizenProfileScreen(state: state),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined, color: Color(0xFF0284C7)),
            title: Text(isHindi ? 'वार्ड जीआईएस रडार मैप' : 'Ward GIS Incident Map'),
            subtitle: const Text('Live pinpoint radar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WardMapScreen(state: state),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined, color: Color(0xFF059669)),
            title: Text(isHindi ? 'नागरिक वार्ड मंच' : 'Ward Community Forum'),
            subtitle: const Text('Deliberation & proposals'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WardForumScreen(state: state),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined, color: Color(0xFFD97706)),
            title: Text(isHindi ? 'सार्वजनिक कार्य व बजट' : 'Public Works & Budget'),
            subtitle: const Text('Capital expenditure & social audit'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PublicWorksScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Badge(
              isLabelVisible: state.unreadNotificationsCount > 0,
              label: Text('${state.unreadNotificationsCount}'),
              child: const Icon(Icons.notifications_none, color: Color(0xFF475569)),
            ),
            title: Text(isHindi ? 'सूचना केंद्र' : 'Municipal Alerts'),
            subtitle: Text('${state.unreadNotificationsCount} unread updates'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationsScreen(state: state),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Color(0xFF2563EB)),
            title: Text(isHindi ? 'सूचना का अधिकार (RTI)' : 'RTI Statutory Portal'),
            subtitle: const Text('File & track 30-day statutory filings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => RtiPortalScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.route_outlined, color: Color(0xFF0D9488)),
            title: Text(isHindi ? 'निरीक्षण रूट प्लानर' : 'Inspection Route Planner'),
            subtitle: const Text('GIS route optimization for officers'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => InspectionRouteScreen(state: state)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism_outlined, color: Color(0xFF16A34A)),
            title: Text(isHindi ? 'नागरिक स्वयंसेवक अभियान' : 'Civic Volunteer Drives'),
            subtitle: const Text('Swachhata & tree plantation drives'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => CivicDrivesScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined, color: Color(0xFFEA580C)),
            title: Text(isHindi ? 'कर व बिल विवाद निवारण' : 'Tax & Utility Disputes'),
            subtitle: const Text('Property & water tariff arbitration'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => UtilityDisputeScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined, color: Color(0xFF047857)),
            title: Text(isHindi ? 'डिजिटल पहचान (KYC)' : 'Digital Identity & KYC'),
            subtitle: const Text('DigiLocker credential verification'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => IdentityVerificationScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined, color: Color(0xFFDC2626)),
            title: Text(isHindi ? 'पशु बचाव व चिकित्सा' : 'Stray Animal Rescue'),
            subtitle: const Text('24x7 Veterinary triage ambulance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AnimalRescueScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined, color: Color(0xFFC2410C)),
            title: Text(isHindi ? 'लू व जलवायु अनुकूलन' : 'Urban Heat Resilience'),
            subtitle: const Text('Cooling centers & heatwave alerts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => HeatResilienceScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.how_to_vote_outlined, color: Color(0xFF4338CA)),
            title: Text(isHindi ? 'सहभागिता बजट मतदान' : 'Participatory Ward Budget'),
            subtitle: const Text('Vote for neighborhood civic funds'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => ParticipatoryBudgetScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront_outlined, color: Color(0xFF059669)),
            title: Text(isHindi ? 'स्ट्रीट वेंडर ज़ोन' : 'Street Vendor Zones'),
            subtitle: const Text('PM SVANidhi slots & licenses'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => StreetVendorScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.sensors_outlined, color: Color(0xFF0284C7)),
            title: Text(isHindi ? 'पर्यावरण आईओटी सेंसर' : 'IoT Telemetry Grid'),
            subtitle: const Text('Air quality & sump monitors'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => IotTelemetryScreen(isHindi: isHindi)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.flood_outlined, color: Color(0xFF0369A1)),
            title: Text(isHindi ? 'मानसून बाढ़ तैयारी' : 'Flood Disaster Preparedness'),
            subtitle: const Text('Monsoon resilience checklists'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => FloodPreparednessScreen(isHindi: isHindi)));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined, color: Colors.red),
            title: Text(isHindi ? 'आपातकालीन सहायता (112)' : 'Emergency SOS Hub'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined, color: Color(0xFF64748B)),
            title: Text(isHindi ? 'सरकारी योजनाएं' : 'Welfare Schemes'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 3);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'JanSeva v2.4 Enterprise • Tripartite Verified',
              style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}
