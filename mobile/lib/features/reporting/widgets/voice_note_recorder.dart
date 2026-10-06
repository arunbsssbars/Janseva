import 'package:flutter/material.dart';

class VoiceNoteRecorder extends StatefulWidget {
  final ValueChanged<String>? onAudioRecorded;
  final ValueChanged<String>? onTranscriptionAvailable;
  final bool isHindi;

  const VoiceNoteRecorder({
    super.key,
    this.onAudioRecorded,
    this.onTranscriptionAvailable,
    this.isHindi = false,
  });

  @override
  State<VoiceNoteRecorder> createState() => _VoiceNoteRecorderState();
}

class _VoiceNoteRecorderState extends State<VoiceNoteRecorder> {
  bool _isRecording = false;
  bool _hasRecorded = false;
  bool _isPlaying = false;
  String _simulatedTranscript = '';

  void _toggleRecording() {
    if (_isRecording) {
      // Stop recording
      setState(() {
        _isRecording = false;
        _hasRecorded = true;
        _simulatedTranscript = widget.isHindi
            ? 'गली नंबर 4 में सीवर लाइन जाम है और पानी सड़क पर भर गया है।'
            : 'Sewer line is blocked in Lane 4 and dirty water is overflowing on the road.';
      });
      widget.onAudioRecorded?.call('audio_note_rec_01.m4a');
      widget.onTranscriptionAvailable?.call(_simulatedTranscript);
    } else {
      // Start recording
      setState(() {
        _isRecording = true;
        _hasRecorded = false;
        _isPlaying = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _isRecording = false;
      _hasRecorded = false;
      _isPlaying = false;
      _simulatedTranscript = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isRecording ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1),
          width: _isRecording ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic_none_rounded,
                size: 18,
                color: _isRecording ? const Color(0xFFEF4444) : const Color(0xFF1E3A8A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHi ? 'आवाज में समस्या दर्ज करें (Voice Note)' : 'Record Voice Grievance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _isRecording ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (_isRecording)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'REC',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Waveform & Controls Strip
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                key: const Key('record_toggle_btn'),
                onPressed: _toggleRecording,
                icon: Icon(
                  _isRecording
                      ? Icons.stop_rounded
                      : (_hasRecorded ? Icons.play_arrow_rounded : Icons.mic_rounded),
                  size: 16,
                ),
                label: Text(
                  _isRecording
                      ? (isHi ? 'रोकें' : 'Stop')
                      : (_hasRecorded
                          ? (_isPlaying ? 'Pause' : 'Listen')
                          : (isHi ? 'रिकॉर्ड करें' : 'Record')),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? const Color(0xFFEF4444) : const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              if (_hasRecorded)
                IconButton(
                  key: const Key('reset_recording_btn'),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFF64748B)),
                  onPressed: _reset,
                  tooltip: 'Re-record',
                  visualDensity: VisualDensity.compact,
                ),
              // Waveform representation
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(8, (index) {
                    final heights = [10.0, 18.0, 14.0, 24.0, 16.0, 20.0, 12.0, 8.0];
                    return Container(
                      width: 3,
                      height: _isRecording || _isPlaying ? heights[index] : 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: _isRecording ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                  const SizedBox(width: 6),
                  Text(
                    _isRecording
                        ? '00:12'
                        : (_hasRecorded ? '00:12' : '00:00'),
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          // Transcription Preview
          if (_hasRecorded && _simulatedTranscript.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, size: 12, color: Color(0xFF8B5CF6)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'AI Bilingual Transcription Preview',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _simulatedTranscript,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
