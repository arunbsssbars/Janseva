enum IndianLanguage {
  hindi,
  english,
  marathi,
  bhojpuri,
  bengali,
  tamil,
  telugu,
  kannada,
  gujarati,
  punjabi,
}

class DialectDetectionResult {
  final IndianLanguage detectedLanguage;
  final String dialectVariant; // e.g., 'Khariboli / Delhi Hindi', 'Bhojpuri Awadhi', 'Standard Marathi'
  final double confidenceScore;
  final String normalizedTranscript;

  const DialectDetectionResult({
    required this.detectedLanguage,
    required this.dialectVariant,
    required this.confidenceScore,
    required this.normalizedTranscript,
  });
}

class DialectDetectionService {
  DialectDetectionResult analyzeAudioSpeech(String rawInput) {
    final lower = rawInput.toLowerCase();

    if (lower.contains('का हो') || lower.contains('रउवा') || lower.contains('बानी') || lower.contains('तहसील')) {
      return DialectDetectionResult(
        detectedLanguage: IndianLanguage.bhojpuri,
        dialectVariant: 'Bhojpuri / Purvanchali',
        confidenceScore: 0.94,
        normalizedTranscript: rawInput,
      );
    }

    if (lower.contains('पाणी') || lower.contains('रस्ता') || lower.contains('नाही') || lower.contains('तक्रार')) {
      return DialectDetectionResult(
        detectedLanguage: IndianLanguage.marathi,
        dialectVariant: 'Western Maharashtra / Deshi',
        confidenceScore: 0.92,
        normalizedTranscript: rawInput,
      );
    }

    if (lower.contains('सड़क') || lower.contains('पानी') || lower.contains('नाली') || lower.contains('समस्या')) {
      return DialectDetectionResult(
        detectedLanguage: IndianLanguage.hindi,
        dialectVariant: 'Khariboli / North Indian Urban',
        confidenceScore: 0.96,
        normalizedTranscript: rawInput,
      );
    }

    return DialectDetectionResult(
      detectedLanguage: IndianLanguage.english,
      dialectVariant: 'Indian English Urban',
      confidenceScore: 0.88,
      normalizedTranscript: rawInput,
    );
  }
}
