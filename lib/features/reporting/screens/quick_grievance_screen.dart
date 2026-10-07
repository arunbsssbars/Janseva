import 'package:flutter/material.dart';
import '../../../core/models/pan_india_directory.dart';
import '../../../core/models/ward.dart';
import '../../../core/services/ai_classifier.dart';
import '../../../core/services/govt_grievance_dispatcher.dart';
import '../../../core/services/native_channel_launcher.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../widgets/voice_petition_sheet.dart';

class QuickGrievanceScreen extends StatefulWidget {
  final JanSevaState state;

  const QuickGrievanceScreen({super.key, required this.state});

  @override
  State<QuickGrievanceScreen> createState() => _QuickGrievanceScreenState();
}

class _QuickGrievanceScreenState extends State<QuickGrievanceScreen> {
  final _inputController = TextEditingController();
  ClassificationResult? _classification;
  GovtGrievanceReceipt? _receipt;
  bool _isSubmitting = false;
  String _selectedQuickIssue = '';
  final List<String> _photos = [];
  MunicipalCorporationInfo _selectedCorporation = PanIndiaDirectory.defaultCorporation;

  void _openVoicePetitionSheet(bool isHi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VoicePetitionSheet(
        isHindi: isHi,
        onPetitionFormulated: (res) {
          setState(() {
            _inputController.text = res.description;
            _selectedQuickIssue = res.title;
          });
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _oneTapIssues = [
    {
      'labelEn': 'Broken Pothole',
      'labelHi': 'सड़क पर गड्ढा',
      'icon': Icons.warning_amber_rounded,
      'text': 'Deep crater pothole causing road traffic danger near market',
    },
    {
      'labelEn': 'Overflowing Garbage',
      'labelHi': 'कचरा ओवरफ्लो',
      'icon': Icons.delete_outline,
      'text': 'Overflowing municipal garbage bin blocking public sidewalk',
    },
    {
      'labelEn': 'Pipeline Leak',
      'labelHi': 'पानी का पाइप रिसाव',
      'icon': Icons.water_drop_outlined,
      'text': 'Main drinking water distribution pipe burst and leaking on street',
    },
    {
      'labelEn': 'Dark Streetlight',
      'labelHi': 'स्ट्रीट लाइट बंद',
      'icon': Icons.lightbulb_outline,
      'text': 'Streetlights not functioning along residential street making it dark',
    },
    {
      'labelEn': 'Open Drain / Manhole',
      'labelHi': 'खुला नाला या गटर',
      'icon': Icons.waves,
      'text': 'Hazardous open manhole and clogged sewage backflow on lane',
    },
  ];

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _classification = AiCivicClassifier.classify(text);
      });
    } else {
      setState(() {
        _classification = null;
      });
    }
  }

  void _selectQuickIssue(Map<String, dynamic> issue) {
    setState(() {
      _selectedQuickIssue = issue['labelEn'] as String;
      _inputController.text = issue['text'] as String;
    });
  }

  void _addSamplePhoto() {
    setState(() {
      _photos.add('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=600');
    });
  }

  Future<void> _submitQuickGrievance() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    final classification = _classification ?? AiCivicClassifier.classify(text);
    final currentWard = widget.state.wards.isNotEmpty
        ? widget.state.wards.first
        : const Ward(
            id: 'W-01',
            wardNumber: 1,
            wardName: 'Civil Lines',
            zone: 'North Zone',
            officerName: 'Sanjay Verma',
            officerPhone: '+91 98100 11223',
            officerEmail: 'sanjay.verma@janseva.gov.in',
          );

    try {
      final grievance = await widget.state.createGrievance(
        title: text.length > 50 ? '${text.substring(0, 47)}...' : text,
        description: text,
        category: classification.category,
        priority: classification.priority,
        wardId: currentWard.id,
        wardName: currentWard.wardName,
        address: 'Current Geo-Tagged Street Location',
        landmark: 'Auto-Resolved Ward Sector',
        latitude: 28.6139,
        longitude: 77.2090,
        photoUrls: _photos,
      );

      final receipt = GovtGrievanceDispatcher.dispatchToGovtPortal(
        grievanceId: grievance.id,
        category: grievance.category,
        citizenPhone: widget.state.currentUser.phoneNumber,
        wardName: currentWard.wardName,
      );

      setState(() {
        _receipt = receipt;
        _isSubmitting = false;
      });
    } catch (_) {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.state.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'त्वरित 3-चरणीय शिकायत दर्ज करें' : 'Quick 3-Step Govt Grievance',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: CivicColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _receipt != null
          ? _buildSuccessReceiptView(_receipt!, isHi)
          : LayoutBuilder(
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
                      // Step Indicator Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded, color: CivicColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isHi
                                    ? 'न्यूनतम विवरण: फोटो या 1-टैप से सीधा सरकारी पोर्टल पर प्रेषित।'
                                    : 'Minimum input: 1-Tap snap routes directly to central & state civic boards.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Step 1: 1-Tap Quick Common Problems
                      Text(
                        isHi ? 'चरण 1: समस्या चुनें (या नीचे लिखें)' : 'Step 1: Pick Issue (or type below)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _oneTapIssues.map((issue) {
                            final isSelected = _selectedQuickIssue == issue['labelEn'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                avatar: Icon(issue['icon'] as IconData, size: 16),
                                selected: isSelected,
                                label: Text(isHi ? (issue['labelHi'] as String) : (issue['labelEn'] as String)),
                                onSelected: (_) => _selectQuickIssue(issue),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Input TextField
                      TextField(
                        controller: _inputController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: isHi
                              ? 'समस्या बताएं (उदा. मुख्य मार्ग पर गड्ढा या नाली बंद)...'
                              : 'Describe the issue or speak (e.g. broken road, leaking valve)...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Photo Attachment Row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _addSamplePhoto,
                            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                            label: Text(
                              isHi ? 'कैमरा फोटो जोड़ें' : 'Add Photo Snap',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _openVoicePetitionSheet(isHi),
                            icon: const Icon(Icons.mic_rounded, color: Colors.deepOrange, size: 18),
                            label: Text(
                              isHi ? 'बोलकर शिकायत करें (Voice AI)' : 'Speak Voice Note (Vernacular AI)',
                              style: const TextStyle(fontSize: 12, color: Colors.deepOrange, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_photos.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Text(
                                isHi ? '${_photos.length} फोटो संलग्न' : '${_photos.length} Photo attached',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Pan-India Municipal Corporation & City Selector
                      Text(
                        isHi ? 'नगर निगम / शहर क्षेत्र चुनें:' : 'Select Municipal Corporation / City:',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<MunicipalCorporationInfo>(
                            isExpanded: true,
                            value: _selectedCorporation,
                            items: PanIndiaDirectory.corporations.map((c) {
                              return DropdownMenuItem(
                                value: c,
                                child: Text(
                                  isHi ? '${c.nameHi} (${c.stateName})' : '${c.nameEn} (${c.stateName})',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedCorporation = val);
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Step 2: Auto-Triage & Department Routing Preview
                      if (_classification != null) ...[
                        Text(
                          isHi ? 'चरण 2: सरकारी विभाग स्वचालित पहचान' : 'Step 2: AI Department Routing Preview',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        _buildRoutingCard(_classification!, isHi),
                        const SizedBox(height: 16),
                      ],

                      // Step 3: One-Tap Dispatch Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _inputController.text.trim().isNotEmpty && !_isSubmitting
                              ? _submitQuickGrievance
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CivicColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(
                            isHi ? 'चरण 3: तुरंत सरकार को भेजें' : 'Step 3: Dispatch to Government',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRoutingCard(ClassificationResult result, bool isHi) {
    final routing = GovtGrievanceDispatcher.resolveRouting(result.category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CivicColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  routing.targetPortal.nameEn,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: CivicColors.primary,
                  ),
                ),
              ),
              Text(
                'SLA: ${routing.statutorySlaHours}h',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isHi ? routing.departmentNameHi : routing.departmentNameEn,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '${isHi ? "नोडल अधिकारी" : "Nodal Officer"}: ${routing.nodalOfficerDesignation}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
          Text(
            '${isHi ? "हेल्पलाइन" : "Direct Helpline"}: ${routing.helplineNumber}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessReceiptView(GovtGrievanceReceipt receipt, bool isHi) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 64),
            const SizedBox(height: 12),
            Text(
              isHi ? 'शिकायत सरकारी पोर्टल पर दर्ज!' : 'Grievance Dispatched to Government!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isHi ? 'सरकारी डॉकेट नंबर' : 'Statutory Government Docket Number',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Text(
                receipt.docketNumber,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${isHi ? "विभाग" : "Department"}: ${isHi ? receipt.departmentNameHi : receipt.departmentNameEn}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isHi ? "समय सीमा" : "Statutory SLA"}: ${receipt.slaHours} ${isHi ? "घंटे" : "Hours"}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isHi ? "अधिकारी" : "Nodal Officer"}: ${receipt.nodalOfficer}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isHi ? 'नागरिक त्वरित कार्रवाई (1-टैप):' : 'Instant Citizen Actions (1-Tap):',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42),
                    ),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(isHi ? 'व्हाट्सएप भेजें' : 'WhatsApp Ward'),
                    onPressed: () {
                      NativeChannelLauncher.sendWhatsAppComplaint(
                        message: '''
🚨 *CITIZEN CIVIC DISPATCH - JANSEVA*
Docket No: ${receipt.docketNumber}
Department: ${receipt.departmentNameEn}
Statutory SLA: ${receipt.slaHours} Hours
Nodal Officer: ${receipt.nodalOfficer}
Issue Details: ${_inputController.text}

Track status: https://janseva.gov.in/track/${receipt.docketNumber}
''',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42),
                    ),
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(isHi ? 'अधिकारी को कॉल' : 'Call Helpline'),
                    onPressed: () {
                      NativeChannelLauncher.dialHelpline(receipt.helplineNumber);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(isHi ? 'डॉकेट कॉपी' : 'Copy Docket'),
                    onPressed: () {
                      NativeChannelLauncher.copyToClipboard(
                        context,
                        receipt.docketNumber,
                        successMessage: 'Docket ${receipt.docketNumber} copied to clipboard!',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_browser, size: 16),
                    label: Text(isHi ? 'सरकारी पोर्टल' : 'Govt Portal'),
                    onPressed: () {
                      NativeChannelLauncher.openOfficialPortal(receipt.portal);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: CivicColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
              child: Text(isHi ? 'होम स्क्रीन पर जाएं' : 'Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
