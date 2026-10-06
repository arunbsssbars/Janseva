import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/core/localization/civic_strings.dart';

void main() {
  group('CivicStrings Bilingual Localization Tests', () {
    test('English strings return expected civic terminology', () {
      expect(CivicStrings.get('appName', isHindi: false), equals('JanSeva'));
      expect(CivicStrings.get('fileGrievance', isHindi: false), equals('File Grievance'));
      expect(CivicStrings.get('statusResolved', isHindi: false), equals('Resolved'));
    });

    test('Hindi strings return accurate localized terms', () {
      expect(CivicStrings.get('appName', isHindi: true), equals('जनसेवा'));
      expect(CivicStrings.get('fileGrievance', isHindi: true), equals('शिकायत दर्ज करें'));
      expect(CivicStrings.get('statusResolved', isHindi: true), equals('निस्तारित'));
    });

    test('Unknown keys fallback safely to key string', () {
      expect(CivicStrings.get('unknown_custom_key', isHindi: true), equals('unknown_custom_key'));
    });
  });
}
