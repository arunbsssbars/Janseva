import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/theme/civic_colors.dart';

class VoicePetitionResult {
  final String title;
  final String description;
  final GrievanceCategory category;
  final GrievancePriority priority;
  final String spokenText;

  const VoicePetitionResult({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.spokenText,
  });
}

class VoicePetitionSheet extends StatefulWidget {
  final bool isHindi;
  final ValueChanged<VoicePetitionResult> onPetitionFormulated;

  const VoicePetitionSheet({
    super.key,
    required this.isHindi,
    required this.onPetitionFormulated,
  });

  @override
  State<VoicePetitionSheet> createState() => _VoicePetitionSheetState();
}

class _VoicePetitionSheetState extends State<VoicePetitionSheet>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _liveTranscript = '';
  late AnimationController _animController;

  static const List<VoicePetitionResult> sampleVoiceInputs = [
    VoicePetitionResult(
      spokenText: 'भैया हमारे मोहल्ले में 3 दिन से पानी नहीं आ रहा है और नाली का गंदा पानी सड़क पर बह रहा है।',
      title: '3-Day Municipal Tap Water Outage & Sewer Overflow',
      description: 'Severe municipal water supply cutoff persisting for 72+ hours. Concurrently, contaminated sewage backflow is overflowing across the residential street posing urgent health risk.',
      category: GrievanceCategory.waterSupply,
      priority: GrievancePriority.emergency,
    ),
    VoicePetitionResult(
      spokenText: 'ट्रांसफार्मर में बहुत तेज स्पार्किंग हो रही है और कभी भी आग लग सकती है, तुरंत टीम भेजो।',
      title: 'Severe High-Voltage Transformer Arcing Hazard',
      description: 'Localized distribution transformer sparking violently with audible explosions and fire risk. Requires immediate shutdown and repair by DISCOM emergency squad.',
      category: GrievanceCategory.electricityAndStreetlights,
      priority: GrievancePriority.emergency,
    ),
    VoicePetitionResult(
      spokenText: 'स्कूल के सामने 4 दिन से कूड़ा पड़ा है, बहुत बदबू आ रही है और बच्चे बीमार हो रहे हैं।',
      title: 'Rotting Solid Waste Accumulation Opposite Primary School',
      description: 'Unattended municipal garbage dump accumulating for 4 days opposite primary school gate. Pungent odor and vector-borne disease vector risk.',
      category: GrievanceCategory.sanitationAndGarbage,
      priority: GrievancePriority.high,
    ),
    VoicePetitionResult(
      spokenText: 'मेन रोड पर गहरा गड्ढा है, रात में दो बाइक वाले गिर चुके हैं, तुरंत मरम्मत चाहिए।',
      title: 'Deep Trench Hazard on Main Commute Road',
      description: 'Unmarked excavation pothole on main road causing recurring two-wheeler accidents. Bitumen patching and safety barricading required.',
      category: GrievanceCategory.roadsAndPotholes,
      priority: GrievancePriority.emergency,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _simulateSpeechRecognition(VoicePetitionResult sample) {
    setState(() {
      _isListening = true;
      _liveTranscript = sample.spokenText;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isListening = false);
        widget.onPetitionFormulated(sample);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.record_voice_over_rounded, color: CivicColors.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHi ? 'नागरिक मौखिक शिकायत (AI भाषा अनुवाद)' : 'Vernacular Voice-to-Petition AI',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      isHi ? 'अपनी भाषा में बोलें, JanSeva इसे सरकारी प्रपत्र में बदलेगा' : 'Speak in your language; JanSeva drafts the legal complaint',
                      style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Central Mic Pulse
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final scale = _isListening ? 1.0 + (_animController.value * 0.15) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: GestureDetector(
                    onTap: () => _simulateSpeechRecognition(sampleVoiceInputs.first),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : CivicColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.red : CivicColors.primary)
                                .withValues(alpha: 0.35),
                            blurRadius: _isListening ? 25 : 10,
                            spreadRadius: _isListening ? 6 : 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          Text(
            _isListening
                ? (isHi ? 'सुन रहा हूँ... बोलिए...' : 'Listening... Speak now...')
                : (isHi ? 'बोलने के लिए माइक दबाएं या नीचे से चुनें' : 'Tap mic to speak or select a common real problem below:'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isListening ? Colors.red : CivicColors.textSecondary,
            ),
          ),

          if (_liveTranscript.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Text(
                '🗣️ "$_liveTranscript"',
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
          ],

          const SizedBox(height: 18),

          Text(
            isHi ? 'आम नागरिक की वास्तविक समस्याएं (1-टैप परीक्षण):' : 'Real-World Common Man Scenarios (1-Tap Test):',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),

          ...sampleVoiceInputs.map((sample) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              color: const Color(0xFFF8FAFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.mic, size: 20, color: CivicColors.primary),
                title: Text(
                  sample.spokenText,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${sample.category.displayNameEn} • ${sample.priority.label}',
                  style: const TextStyle(fontSize: 10, color: CivicColors.textSecondary),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _simulateSpeechRecognition(sample),
              ),
            );
          }),
        ],
      ),
    );
  }
}
