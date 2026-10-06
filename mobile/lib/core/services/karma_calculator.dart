import '../models/grievance.dart';
import '../models/user_profile.dart';

enum CivicTier {
  bronze(title: 'Active Resident', titleHi: 'सक्रिय नागरिक', minScore: 0, colorHex: 0xFFCD7F32),
  silver(title: 'Community Contributor', titleHi: 'समुदाय सहयोगी', minScore: 300, colorHex: 0xFF94A3B8),
  gold(title: 'Civic Guardian', titleHi: 'नागरिक संरक्षक', minScore: 600, colorHex: 0xFFEAB308),
  platinum(title: 'Platinum Civic Champion', titleHi: 'प्लैटिनम नागरिक चैंपियन', minScore: 850, colorHex: 0xFF3B82F6);

  const CivicTier({
    required this.title,
    required this.titleHi,
    required this.minScore,
    required this.colorHex,
  });

  final String title;
  final String titleHi;
  final int minScore;
  final int colorHex;
}

class CivicKarmaScore {
  final int score; // 0 to 1000
  final CivicTier tier;
  final int verifiedReportsCount;
  final int upvotesGivenCount;
  final int resolutionsRatedCount;
  final double percentileRank; // Top X%

  const CivicKarmaScore({
    required this.score,
    required this.tier,
    required this.verifiedReportsCount,
    required this.upvotesGivenCount,
    required this.resolutionsRatedCount,
    required this.percentileRank,
  });
}

class CivicKarmaCalculator {
  static CivicKarmaScore computeKarma({
    required UserProfile user,
    required List<Grievance> allGrievances,
  }) {
    final userGrievances = allGrievances.where((g) => g.citizenId == user.id).toList();

    int verifiedReports = userGrievances.where((g) => g.status.isTerminal).length;
    int upvotesGiven = user.totalUpvotesGiven;
    int resolutionsRated = userGrievances.where((g) => g.citizenRating != null).length;

    // Baseline 200 points
    int points = 200;
    points += userGrievances.length * 40;
    points += verifiedReports * 60;
    points += upvotesGiven * 10;
    points += resolutionsRated * 30;

    final clampedScore = points.clamp(0, 1000);

    CivicTier tier = CivicTier.bronze;
    if (clampedScore >= CivicTier.platinum.minScore) {
      tier = CivicTier.platinum;
    } else if (clampedScore >= CivicTier.gold.minScore) {
      tier = CivicTier.gold;
    } else if (clampedScore >= CivicTier.silver.minScore) {
      tier = CivicTier.silver;
    }

    final percentile = (100.0 - (clampedScore / 1000.0 * 85.0)).clamp(5.0, 95.0);

    return CivicKarmaScore(
      score: clampedScore,
      tier: tier,
      verifiedReportsCount: verifiedReports,
      upvotesGivenCount: upvotesGiven,
      resolutionsRatedCount: resolutionsRated,
      percentileRank: percentile,
    );
  }
}
