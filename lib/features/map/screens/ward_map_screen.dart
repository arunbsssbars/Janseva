import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/models/grievance.dart';
import '../../../core/models/ward.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../tracking/screens/grievance_detail_screen.dart';

class WardMapScreen extends StatefulWidget {
  final JanSevaState state;

  const WardMapScreen({super.key, required this.state});

  @override
  State<WardMapScreen> createState() => _WardMapScreenState();
}

class _WardMapScreenState extends State<WardMapScreen> {
  String? _selectedWardId;
  GrievanceCategory? _selectedCategory;
  String? _selectedGrievanceId;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;

    // Filter grievances
    final filtered = state.grievances.where((g) {
      if (_selectedWardId != null && g.wardId != _selectedWardId) return false;
      if (_selectedCategory != null && g.category != _selectedCategory) return false;
      return true;
    }).toList();

    final selectedGrievance = filtered.firstWhere(
      (g) => g.id == _selectedGrievanceId,
      orElse: () => filtered.isNotEmpty ? filtered.first : state.grievances.first,
    );

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'वार्ड भू-स्थानिक मानचित्र' : 'Ward Geospatial Map',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter section: Wards and Categories
            _buildFilterSection(isHindi),

            const SizedBox(height: 14),

            // Map Header Bar
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  '${isHindi ? "सक्रिय घटनाएं" : "Active Incidents"}: ${filtered.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CivicColors.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.gps_fixed, size: 12, color: CivicColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        isHindi ? 'जीआईएस रडार सक्रिय' : 'GIS Live Grid',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: CivicColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // GIS Canvas / Interactive Pinpoint Visualizer
            _buildInteractiveMapCanvas(filtered, selectedGrievance),

            const SizedBox(height: 16),

            // Selected Pin Details Card
            if (filtered.isNotEmpty)
              _buildPinDetailCard(selectedGrievance, isHindi)
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CivicColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    isHindi ? 'इस चयन में कोई घटना दर्ज नहीं है।' : 'No incidents match current map filters.',
                    style: const TextStyle(fontSize: 13, color: CivicColors.textMuted),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Ward Statistics Grid
            _buildWardMetrics(filtered, isHindi),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ward Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(isHindi ? 'सभी वार्ड' : 'All Wards'),
                  selected: _selectedWardId == null,
                  onSelected: (_) => setState(() => _selectedWardId = null),
                ),
              ),
              ...Ward.defaultWards().map((w) {
                final isSelected = _selectedWardId == w.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text('W-${w.wardNumber} ${w.wardName}'),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedWardId = isSelected ? null : w.id),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(isHindi ? 'सभी श्रेणियां' : 'All Categories'),
                  selected: _selectedCategory == null,
                  onSelected: (_) => setState(() => _selectedCategory = null),
                ),
              ),
              ...GrievanceCategory.values.take(4).map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(isHindi ? cat.displayNameHi : cat.displayNameEn),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = isSelected ? null : cat),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveMapCanvas(List<Grievance> grievances, Grievance selected) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark GIS radar background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CivicColors.border),
      ),
      child: Stack(
        children: [
          // GIS Grid Lines
          CustomPaint(
            size: const Size(double.infinity, 220),
            painter: _GisGridPainter(),
          ),

          // Incident Pins
          ...grievances.asMap().entries.map((entry) {
            final idx = entry.key;
            final g = entry.value;
            final isSelected = g.id == selected.id;

            // Deterministic distribution across canvas
            final double left = (30 + ((idx * 67 + g.wardId.hashCode.abs()) % 220)).toDouble();
            final double top = (20 + ((idx * 43 + g.title.length * 11) % 150)).toDouble();

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => setState(() => _selectedGrievanceId = g.id),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CivicColors.primary
                            : (g.isSlaBreached ? CivicColors.error : const Color(0xFF38BDF8)),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isSelected ? CivicColors.primary : Colors.white).withValues(alpha: 0.5),
                            blurRadius: isSelected ? 10 : 4,
                            spreadRadius: isSelected ? 2 : 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        _iconForCategory(g.category),
                        size: isSelected ? 16 : 12,
                        color: Colors.white,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          g.wardName,
                          style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPinDetailCard(Grievance g, bool isHindi) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: CivicColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                CivicCategoryChip(category: g.category, isHindi: isHindi),
                CivicStatusBadge(status: g.status, isHindi: isHindi),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              g.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: CivicColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${g.wardName} • ${g.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                CivicSlaCountdownChip(
                  slaDeadline: g.slaDeadline,
                  isBreached: g.isSlaBreached,
                  remaining: g.timeRemainingUntilSla,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrievanceDetailScreen(
                          grievanceId: g.id,
                          state: widget.state,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: Text(
                    isHindi ? 'विवरण देखें' : 'View Details',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: const Size(64, 34),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWardMetrics(List<Grievance> grievances, bool isHindi) {
    final breachedCount = grievances.where((g) => g.isSlaBreached).length;
    final inProgressCount = grievances.where((g) => g.status == GrievanceStatus.inProgress).length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            title: isHindi ? 'कुल चिन्हित' : 'Mapped',
            value: '${grievances.length}',
            color: CivicColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: isHindi ? 'कार्य प्रगति पर' : 'In Progress',
            value: '$inProgressCount',
            color: CivicColors.secondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: isHindi ? 'अवधि उल्लंघन' : 'Breached',
            value: '$breachedCount',
            color: CivicColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(GrievanceCategory category) {
    switch (category) {
      case GrievanceCategory.roadsAndPotholes:
        return Icons.traffic;
      case GrievanceCategory.sanitationAndGarbage:
        return Icons.delete_outline;
      case GrievanceCategory.waterSupply:
        return Icons.water_drop_outlined;
      case GrievanceCategory.electricityAndStreetlights:
        return Icons.lightbulb_outline;
      case GrievanceCategory.sewageAndDrainage:
        return Icons.waves;
      case GrievanceCategory.publicSafetyAndHazards:
        return Icons.warning_amber_rounded;
      case GrievanceCategory.strayAnimals:
        return Icons.pets;
      case GrievanceCategory.illegalEncroachment:
        return Icons.domain_disabled;
    }
  }
}

class _GisGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Concentric radar circles
    final circlePaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 40, circlePaint);
    canvas.drawCircle(center, 80, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
