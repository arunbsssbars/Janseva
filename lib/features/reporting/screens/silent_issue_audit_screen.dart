import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';

class SilentIssueAuditScreen extends StatefulWidget {
  final JanSevaState state;

  const SilentIssueAuditScreen({super.key, required this.state});

  @override
  State<SilentIssueAuditScreen> createState() => _SilentIssueAuditScreenState();
}

class _SilentIssueAuditScreenState extends State<SilentIssueAuditScreen> {
  final List<Map<String, dynamic>> _silentIssues = [
    {
      'id': 'SIL-01',
      'title': 'Silent Water Pressure Drop in Sector 4',
      'category': 'Water Supply',
      'civicCat': GrievanceCategory.waterSupply,
      'ward': 'Ward 1 - Civil Lines',
      'unreportedDays': 4,
      'corroborations': 6,
      'reasonUnreported': 'Citizens assumed temporary pipeline maintenance.',
      'hasCorroborated': false,
    },
    {
      'id': 'SIL-02',
      'title': 'Dark Stretch - 7 Consecutive Defective Lights',
      'category': 'Electricity',
      'civicCat': GrievanceCategory.electricityAndStreetlights,
      'ward': 'Ward 2 - Gandhi Nagar',
      'unreportedDays': 8,
      'corroborations': 11,
      'reasonUnreported': 'Passersby thought municipal JE already aware.',
      'hasCorroborated': false,
    },
    {
      'id': 'SIL-03',
      'title': 'Accumulated Debris along School Back Lane',
      'category': 'Sanitation',
      'civicCat': GrievanceCategory.sanitationAndGarbage,
      'ward': 'Ward 3 - Industrial Area',
      'unreportedDays': 5,
      'corroborations': 3,
      'reasonUnreported': 'Lane is infrequently visited by ward sanitary crew.',
      'hasCorroborated': false,
    },
  ];

  final _newSpotController = TextEditingController();
  GrievanceCategory _newCategory = GrievanceCategory.roadsAndPotholes;

  void _corroborateIssue(int index) {
    setState(() {
      final item = _silentIssues[index];
      final current = item['hasCorroborated'] as bool;
      item['hasCorroborated'] = !current;
      item['corroborations'] = (item['corroborations'] as int) + (current ? -1 : 1);
    });
  }

  void _submitNewSilentSpot() {
    final title = _newSpotController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _silentIssues.insert(0, {
        'id': 'SIL-0${_silentIssues.length + 1}',
        'title': title,
        'category': _newCategory.displayNameEn,
        'civicCat': _newCategory,
        'ward': 'Ward 1 - Civil Lines',
        'unreportedDays': 1,
        'corroborations': 1,
        'reasonUnreported': 'Flagged by citizen proactive neighborhood scan.',
        'hasCorroborated': true,
      });
      _newSpotController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF059669),
        content: Text('Unreported problem recorded! Escalating to Municipal JE.'),
      ),
    );
  }

  @override
  void dispose() {
    _newSpotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.state.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'अप्रत्यक्ष समस्या हंटर (Zero Complaint Audit)' : 'Silent Issue Civic Hunter',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Philosophy Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.radar_rounded, color: Color(0xFF0F766E), size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isHi
                                  ? 'सरकारी रिकॉर्ड में शून्य शिकायत? समस्या पकड़ें!'
                                  : 'Zero Complaints in Govt Records? Hunt Silent Issues!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF115E59),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isHi
                            ? 'अक्सर नागरिक शिकायत दर्ज नहीं करते और विभाग "सब ठीक है" मान लेते हैं। यहां अप्रत्यक्ष समस्याओं को चिन्हित करें।'
                            : 'Citizens often remain silent while civic decay persists. Flag unspoken issues so municipal engineers act before failures happen.',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF0F766E)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Flag Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHi ? 'कोई अनदेखी समस्या तुरंत रिपोर्ट करें:' : 'Flag an Unreported Local Defect:',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _newSpotController,
                        decoration: InputDecoration(
                          hintText: isHi ? 'उदा. स्कूल के पास सड़क धंस रही है...' : 'e.g. Sinking road near school...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: DropdownButton<GrievanceCategory>(
                              value: _newCategory,
                              isDense: true,
                              isExpanded: true,
                              items: GrievanceCategory.values.map((c) {
                                return DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    isHi ? c.displayNameHi : c.displayNameEn,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _newCategory = v);
                              },
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _submitNewSilentSpot,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: Text(isHi ? 'दर्ज करें' : 'Flag Defect', style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  isHi ? 'सत्यापन के लिए पहचानी गई अनदेखी समस्याएं:' : 'Unreported Issues Awaiting Community Corroboration:',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Silent Issues List
                ..._silentIssues.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final hasCorroborated = item['hasCorroborated'] as bool;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['category'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                              Text(
                                '${item["unreportedDays"]} ${isHi ? "दिनों से अनसुलझा" : "Days Unreported"}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['ward'] as String,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${isHi ? "नागरिक कारण" : "Root cause"}: ${item["reasonUnreported"]}',
                            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                          const Divider(height: 16),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Text(
                                '${item["corroborations"]} ${isHi ? "नागरिकों ने पुष्टि की" : "Citizens Corroborated"}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _corroborateIssue(idx),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hasCorroborated
                                      ? const Color(0xFF059669)
                                      : CivicColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                icon: Icon(
                                  hasCorroborated ? Icons.check : Icons.thumb_up_alt_outlined,
                                  size: 14,
                                ),
                                label: Text(
                                  hasCorroborated
                                      ? (isHi ? 'पुष्टि हो चुकी' : 'Confirmed')
                                      : (isHi ? 'मैं भी पुष्टि करता हूं' : 'I Confirm This'),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
