import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/flood_prep_item.dart';

class FloodPreparednessScreen extends StatefulWidget {
  final bool isHindi;

  const FloodPreparednessScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<FloodPreparednessScreen> createState() => _FloodPreparednessScreenState();
}

class _FloodPreparednessScreenState extends State<FloodPreparednessScreen> {
  late List<FloodPrepCheckItem> _checklist;

  @override
  void initState() {
    super.initState();
    _checklist = [
      const FloodPrepCheckItem(
        id: 'FLD-01',
        category: 'Drainage',
        title: 'Clear Compound Stormwater Drain Gratings',
        description: 'Remove dried leaves and silt debris from exterior drain grates to avert basement flood backflow.',
        isCompleted: true,
      ),
      const FloodPrepCheckItem(
        id: 'FLD-02',
        category: 'Electrical Safety',
        title: 'Elevate Ground-Floor Plug Extensions',
        description: 'Ensure circuit trip MCBs are functional and electrical appliances are lifted above flood sill.',
        isCompleted: false,
      ),
      const FloodPrepCheckItem(
        id: 'FLD-03',
        category: 'Emergency Kit',
        title: 'Pack Waterproof Emergency Go-Bag',
        description: 'Store photocopies of Aadhaar/deeds, flashlight, first aid, ORS packets, and powerbank.',
        isCompleted: true,
      ),
      const FloodPrepCheckItem(
        id: 'FLD-04',
        category: 'Evacuation',
        title: 'Identify Ward High-Ground Relief Shelter',
        description: 'Note coordinates of nearest municipal relief center and disaster control room helpline (1077).',
        isCompleted: false,
      ),
    ];
  }

  void _toggleCheck(String id) {
    setState(() {
      _checklist = _checklist.map((item) {
        if (item.id == id) {
          return item.copyWith(isCompleted: !item.isCompleted);
        }
        return item;
      }).toList();
    });
  }

  int get _completedCount => _checklist.where((i) => i.isCompleted).length;
  double get _readinessScore =>
      _checklist.isEmpty ? 0.0 : (_completedCount / _checklist.length).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'मानसून बाढ़ आपदा तैयारी' : 'Monsoon Flood Preparedness',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0369A1),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Readiness Gauge Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          isHi ? 'नागरिक बाढ़ तत्परता स्कोर' : 'Ward Resilience Readiness',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(_readinessScore * 100).toInt()}% Ready',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _readinessScore,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_completedCount of ${_checklist.length} actions verified before rainfall onset.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Checklist
            Text(
              isHi ? 'आपदा पूर्व सुरक्षा चेकलिस्ट' : 'Household & Community Checklist',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            ..._checklist.map((item) => _buildCheckItem(item, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(FloodPrepCheckItem item, bool isHi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: item.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            key: Key('check_${item.id}'),
            value: item.isCompleted,
            activeColor: const Color(0xFF059669),
            onChanged: (_) => _toggleCheck(item.id),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
