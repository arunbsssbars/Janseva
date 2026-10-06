import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/enums/civic_enums.dart';
import 'package:janseva_mobile/core/services/ai_classifier.dart';

void main() {
  group('AiCivicClassifier Unit Tests', () {
    test('Classifies pothole report accurately as roadsAndPotholes', () {
      const text = 'Massive pothole on asphalt road divider near metro pillar 45';
      final result = AiCivicClassifier.classify(text);

      expect(result.category, GrievanceCategory.roadsAndPotholes);
      expect(result.confidence, greaterThanOrEqualTo(0.85));
      expect(result.isHazardDetected, isFalse);
    });

    test('Detects Hindi keywords for sewage & drainage', () {
      const text = 'कालोनी में सीवेज और नाली का गंदा पानी सड़क पर बह रहा है';
      final result = AiCivicClassifier.classify(text);

      expect(result.category, GrievanceCategory.sewageAndDrainage);
      expect(result.confidence, greaterThanOrEqualTo(0.65));
      expect(result.departmentName, contains('Drainage'));
    });

    test('Elevates priority to emergency when hazard keywords are present', () {
      const text = 'Electric pole transformer spark and open wire sparking near school gate';
      final result = AiCivicClassifier.classify(text);

      expect(result.category, GrievanceCategory.electricityAndStreetlights);
      expect(result.isHazardDetected, isTrue);
      expect(result.priority, GrievancePriority.emergency);
      expect(result.confidence, greaterThanOrEqualTo(0.90));
    });

    test('Correctly routes stray animal complaints to veterinary cell', () {
      const text = 'Aggressive pack of stray dog biting pedestrians in market';
      final result = AiCivicClassifier.classify(text);

      expect(result.category, GrievanceCategory.strayAnimals);
      expect(result.departmentName, contains('Veterinary'));
    });

    test('Empty text gracefully returns default with 0 confidence', () {
      final result = AiCivicClassifier.classify('   ');
      expect(result.confidence, 0.0);
      expect(result.isHazardDetected, isFalse);
    });
  });
}
