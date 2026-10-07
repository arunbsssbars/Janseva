import '../enums/civic_enums.dart';

class ClassificationResult {
  final GrievanceCategory category;
  final GrievancePriority priority;
  final String departmentName;
  final String departmentNameHi;
  final double confidence; // 0.0 to 1.0
  final bool isHazardDetected;
  final List<String> detectedKeywords;

  const ClassificationResult({
    required this.category,
    required this.priority,
    required this.departmentName,
    required this.departmentNameHi,
    required this.confidence,
    required this.isHazardDetected,
    required this.detectedKeywords,
  });
}

class AiCivicClassifier {
  static const Map<GrievanceCategory, List<String>> _categoryKeywords = {
    GrievanceCategory.roadsAndPotholes: [
      'road', 'pothole', 'asphalt', 'tar', 'crater', 'divider', 'footpath', 'sidewalk',
      'सड़क', 'गड्ढा', 'फुटपाथ', 'डामर', 'रास्ता'
    ],
    GrievanceCategory.sanitationAndGarbage: [
      'garbage', 'trash', 'waste', 'dump', 'bin', 'litter', 'smell', 'stench', 'dead animal',
      'कचरा', 'कूड़ा', 'गंदगी', 'डस्टबिन', 'सफाई'
    ],
    GrievanceCategory.waterSupply: [
      'water', 'pipeline', 'leak', 'tap', 'pressure', 'dirty water', 'contamination', 'tanker',
      'पानी', 'जल', 'पाइप', 'रिसाव', 'नल', 'टैंकर', 'गंदा पानी'
    ],
    GrievanceCategory.electricityAndStreetlights: [
      'electric', 'light', 'streetlight', 'pole', 'transformer', 'spark', 'blackout', 'wire',
      'बिजली', 'लाइट', 'स्ट्रीट लाइट', 'खंभा', 'तार', 'ट्रांसफार्मर'
    ],
    GrievanceCategory.sewageAndDrainage: [
      'sewage', 'drain', 'gutter', 'overflow', 'manhole', 'clogged drain', 'nullah',
      'सीवेज', 'नाली', 'गटर', 'मैनहोल', 'नाल'
    ],
    GrievanceCategory.publicSafetyAndHazards: [
      'danger', 'collapse', 'fire', 'accident', 'open wire', 'hazard', 'emergency',
      'खतरा', 'आग', 'दुर्घटना', 'खुला तार', 'आपदा'
    ],
    GrievanceCategory.strayAnimals: [
      'dog', 'stray', 'bite', 'cattle', 'monkey', 'cow', 'animal pack',
      'कुत्ता', 'आवारा', 'काटना', 'बंदर', 'गाय', 'पशु'
    ],
    GrievanceCategory.illegalEncroachment: [
      'encroach', 'illegal', 'construction', 'blocked lane', 'hawker', 'squatter',
      'अतिक्रमण', 'अवैध', 'निर्माण', 'कब्जा'
    ],
  };

  static const List<String> _hazardKeywords = [
    'spark', 'fire', 'open wire', 'burst', 'open manhole', 'child fallen', 'current',
    'आग', 'चिंगारी', 'खुला मैनहोल', 'करंट', 'धमाका', 'खतरा'
  ];

  static ClassificationResult classify(String text) {
    final lower = text.toLowerCase();
    if (lower.trim().isEmpty) {
      return const ClassificationResult(
        category: GrievanceCategory.roadsAndPotholes,
        priority: GrievancePriority.medium,
        departmentName: 'Public Works Department (PWD)',
        departmentNameHi: 'लोक निर्माण विभाग (पीडब्ल्यूडी)',
        confidence: 0.0,
        isHazardDetected: false,
        detectedKeywords: [],
      );
    }

    final List<String> matchedHazards = [];
    for (final hazard in _hazardKeywords) {
      if (lower.contains(hazard)) {
        matchedHazards.add(hazard);
      }
    }
    final isHazard = matchedHazards.isNotEmpty;

    GrievanceCategory bestCategory = GrievanceCategory.roadsAndPotholes;
    int maxMatches = 0;
    List<String> matchedKeywords = [];

    for (final entry in _categoryKeywords.entries) {
      final matches = <String>[];
      for (final kw in entry.value) {
        if (lower.contains(kw)) {
          matches.add(kw);
        }
      }
      if (matches.length > maxMatches) {
        maxMatches = matches.length;
        bestCategory = entry.key;
        matchedKeywords = matches;
      }
    }

    // Determine confidence
    double confidence = 0.40;
    if (maxMatches >= 3) {
      confidence = 0.94;
    } else if (maxMatches == 2) {
      confidence = 0.85;
    } else if (maxMatches == 1) {
      confidence = 0.65;
    }

    // Determine Priority
    GrievancePriority priority = GrievancePriority.medium;
    if (isHazard) {
      priority = GrievancePriority.emergency;
      confidence = (confidence + 0.1).clamp(0.0, 0.98);
    } else if (bestCategory == GrievanceCategory.sewageAndDrainage ||
        bestCategory == GrievanceCategory.waterSupply) {
      priority = GrievancePriority.high;
    } else if (maxMatches >= 2) {
      priority = GrievancePriority.medium;
    }

    // Department routing
    String deptEn;
    String deptHi;
    switch (bestCategory) {
      case GrievanceCategory.roadsAndPotholes:
      case GrievanceCategory.illegalEncroachment:
        deptEn = 'Civil & Works Engineering Division';
        deptHi = 'नागरिक एवं निर्माण अभियांत्रिकी प्रभाग';
        break;
      case GrievanceCategory.sanitationAndGarbage:
        deptEn = 'Solid Waste Management & Sanitation Board';
        deptHi = 'ठोस अपशिष्ट प्रबंधन एवं स्वच्छता बोर्ड';
        break;
      case GrievanceCategory.waterSupply:
      case GrievanceCategory.sewageAndDrainage:
        deptEn = 'Municipal Jal Board & Drainage Unit';
        deptHi = 'नगर जल बोर्ड एवं जल निकासी इकाई';
        break;
      case GrievanceCategory.electricityAndStreetlights:
        deptEn = 'Municipal Electrical Infrastructure Cell';
        deptHi = 'नगर विद्युत अवसंरचना प्रकोष्ठ';
        break;
      case GrievanceCategory.publicSafetyAndHazards:
        deptEn = 'Disaster Management & Emergency Rapid Response';
        deptHi = 'आपदा प्रबंधन एवं त्वरित प्रतिक्रिया दल';
        break;
      case GrievanceCategory.strayAnimals:
        deptEn = 'Veterinary & Animal Welfare Cell';
        deptHi = 'पशु चिकित्सा एवं पशु कल्याण प्रकोष्ठ';
        break;
    }

    return ClassificationResult(
      category: bestCategory,
      priority: priority,
      departmentName: deptEn,
      departmentNameHi: deptHi,
      confidence: confidence,
      isHazardDetected: isHazard,
      detectedKeywords: [...matchedKeywords, ...matchedHazards],
    );
  }
}
