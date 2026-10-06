import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/services/dialect_detection_service.dart';

void main() {
  group('DialectDetectionService Unit Tests', () {
    late DialectDetectionService service;

    setUp(() {
      service = DialectDetectionService();
    });

    test('detects Bhojpuri dialect with high confidence', () {
      final res = service.analyzeAudioSpeech('का हो भइया, नाली के पानी रउवा सड़क पर बहता');
      expect(res.detectedLanguage, equals(IndianLanguage.bhojpuri));
      expect(res.dialectVariant, contains('Bhojpuri'));
      expect(res.confidenceScore, greaterThan(0.90));
    });

    test('detects Marathi language accurately', () {
      final res = service.analyzeAudioSpeech('आमच्या गल्लीत तीन दिवसांपासून पिण्याचे पाणी नाही');
      expect(res.detectedLanguage, equals(IndianLanguage.marathi));
      expect(res.dialectVariant, contains('Maharashtra'));
      expect(res.confidenceScore, greaterThan(0.90));
    });

    test('detects Standard Hindi language accurately', () {
      final res = service.analyzeAudioSpeech('वार्ड 14 में मुख्य सड़क पर बड़ा गड्ढा और कचरा की समस्या है');
      expect(res.detectedLanguage, equals(IndianLanguage.hindi));
      expect(res.confidenceScore, greaterThan(0.90));
    });

    test('defaults to Indian English when Latin text provided', () {
      final res = service.analyzeAudioSpeech('Streetlight near pillar 42 is blinking since 3 nights');
      expect(res.detectedLanguage, equals(IndianLanguage.english));
      expect(res.dialectVariant, equals('Indian English Urban'));
    });
  });
}
