import '../enums/civic_enums.dart';
import '../models/grievance.dart';

class DuplicateMatchResult {
  final Grievance existingGrievance;
  final double similarityScore; // 0.0 to 1.0
  final String reason;

  const DuplicateMatchResult({
    required this.existingGrievance,
    required this.similarityScore,
    required this.reason,
  });
}

class DuplicateGrievanceDetector {
  static List<DuplicateMatchResult> findPotentialDuplicates({
    required List<Grievance> activeGrievances,
    required String newTitle,
    required String newDescription,
    required GrievanceCategory newCategory,
    required String newWardId,
  }) {
    final List<DuplicateMatchResult> matches = [];

    final normalizedNewTitle = newTitle.toLowerCase().trim();
    final newKeywords = _extractKeywords(normalizedNewTitle);

    for (final existing in activeGrievances) {
      if (existing.status == GrievanceStatus.verifiedClosed) continue;

      double score = 0.0;
      final reasons = <String>[];

      // Same Ward bonus
      if (existing.wardId == newWardId) {
        score += 0.3;
        reasons.add('Same ward');
      }

      // Same Category bonus
      if (existing.category == newCategory) {
        score += 0.3;
        reasons.add('Same category');
      }

      // Keyword overlap
      final existingKeywords = _extractKeywords(existing.title.toLowerCase());
      final commonKeywords = newKeywords.intersection(existingKeywords);

      if (commonKeywords.isNotEmpty) {
        final keywordOverlapRatio =
            (commonKeywords.length * 2) / (newKeywords.length + existingKeywords.length);
        score += keywordOverlapRatio * 0.4;
        reasons.add('${commonKeywords.length} common keywords (${commonKeywords.join(', ')})');
      }

      if (score >= 0.6) {
        matches.add(
          DuplicateMatchResult(
            existingGrievance: existing,
            similarityScore: score.clamp(0.0, 1.0),
            reason: reasons.join(' • '),
          ),
        );
      }
    }

    matches.sort((a, b) => b.similarityScore.compareTo(a.similarityScore));
    return matches;
  }

  static Set<String> _extractKeywords(String text) {
    final stopWords = {
      'the', 'is', 'in', 'at', 'of', 'on', 'and', 'a', 'to', 'near', 'by',
      'for', 'with', 'from', 'this', 'that', 'there', 'here', 'please', 'road'
    };
    return text
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toSet();
  }
}
