import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/reporting/widgets/voice_note_recorder.dart';

void main() {
  group('VoiceNoteRecorder AQIL & Audio Simulation Tests', () {
    testWidgets('records audio note and generates simulated AI transcript', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      String? recordedFile;
      String? transcript;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: VoiceNoteRecorder(
                onAudioRecorded: (f) => recordedFile = f,
                onTranscriptionAvailable: (t) => transcript = t,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Record Voice Grievance'), findsOneWidget);
      expect(find.text('Record'), findsOneWidget);

      // Start Recording
      await tester.tap(find.byKey(const Key('record_toggle_btn')));
      await tester.pumpAndSettle();

      expect(find.text('REC'), findsOneWidget);
      expect(find.text('Stop'), findsOneWidget);

      // Stop Recording
      await tester.tap(find.byKey(const Key('record_toggle_btn')));
      await tester.pumpAndSettle();

      expect(recordedFile, equals('audio_note_rec_01.m4a'));
      expect(transcript, isNotNull);
      expect(find.text('AI Bilingual Transcription Preview'), findsOneWidget);
      expect(find.byKey(const Key('reset_recording_btn')), findsOneWidget);

      // Reset
      await tester.tap(find.byKey(const Key('reset_recording_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Record'), findsOneWidget);
      expect(find.text('AI Bilingual Transcription Preview'), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on 320px compact viewport with 1.5x font scale',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: VoiceNoteRecorder(
                isHindi: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('आवाज में समस्या दर्ज करें (Voice Note)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
