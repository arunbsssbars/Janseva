import '../enums/civic_enums.dart';
import '../models/grievance.dart';
import '../models/ward.dart';

class WardPerformanceSummary {
  final Ward ward;
  final int totalCount;
  final int resolvedCount;
  final int breachedCount;
  final double resolutionRate; // 0.0 to 100.0%

  const WardPerformanceSummary({
    required this.ward,
    required this.totalCount,
    required this.resolvedCount,
    required this.breachedCount,
    required this.resolutionRate,
  });
}

class CivicAnalyticsData {
  final int totalGrievances;
  final int resolvedGrievances;
  final int inProgressGrievances;
  final int breachedGrievances;
  final double slaComplianceRate; // 0 to 100%
  final double averageResolutionHours;
  final Map<GrievanceCategory, int> categoryCounts;
  final List<WardPerformanceSummary> wardRankings;

  const CivicAnalyticsData({
    required this.totalGrievances,
    required this.resolvedGrievances,
    required this.inProgressGrievances,
    required this.breachedGrievances,
    required this.slaComplianceRate,
    required this.averageResolutionHours,
    required this.categoryCounts,
    required this.wardRankings,
  });
}

class CivicAnalyticsEngine {
  static CivicAnalyticsData computeAnalytics({
    required List<Grievance> grievances,
    required List<Ward> wards,
  }) {
    if (grievances.isEmpty) {
      return const CivicAnalyticsData(
        totalGrievances: 0,
        resolvedGrievances: 0,
        inProgressGrievances: 0,
        breachedGrievances: 0,
        slaComplianceRate: 100.0,
        averageResolutionHours: 0.0,
        categoryCounts: {},
        wardRankings: [],
      );
    }

    int resolved = 0;
    int inProgress = 0;
    int breached = 0;
    double totalResolutionHours = 0;
    int resolvedWithTimeCount = 0;

    final Map<GrievanceCategory, int> catCounts = {};
    for (final cat in GrievanceCategory.values) {
      catCounts[cat] = 0;
    }

    for (final g in grievances) {
      catCounts[g.category] = (catCounts[g.category] ?? 0) + 1;

      if (g.status == GrievanceStatus.resolved ||
          g.status == GrievanceStatus.verifiedClosed) {
        resolved++;
        if (g.resolvedAt != null) {
          final hours = g.resolvedAt!.difference(g.createdAt).inMinutes / 60.0;
          totalResolutionHours += hours > 0 ? hours : 1.0;
          resolvedWithTimeCount++;
        }
      } else if (g.status == GrievanceStatus.inProgress ||
          g.status == GrievanceStatus.reopened) {
        inProgress++;
      }

      if (g.isSlaBreached) {
        breached++;
      }
    }

    final compliance = grievances.isNotEmpty
        ? (((grievances.length - breached) / grievances.length) * 100.0).clamp(0.0, 100.0)
        : 100.0;

    final avgHours = resolvedWithTimeCount > 0
        ? totalResolutionHours / resolvedWithTimeCount
        : 24.0;

    final List<WardPerformanceSummary> wardSummaries = [];
    for (final ward in wards) {
      final wardGrievances = grievances.where((g) => g.wardId == ward.id).toList();
      final wTotal = wardGrievances.length;
      final wResolved = wardGrievances
          .where((g) =>
              g.status == GrievanceStatus.resolved ||
              g.status == GrievanceStatus.verifiedClosed)
          .length;
      final wBreached = wardGrievances.where((g) => g.isSlaBreached).length;
      final wRate = wTotal > 0 ? (wResolved / wTotal) * 100.0 : 100.0;

      wardSummaries.add(
        WardPerformanceSummary(
          ward: ward,
          totalCount: wTotal,
          resolvedCount: wResolved,
          breachedCount: wBreached,
          resolutionRate: wRate,
        ),
      );
    }

    wardSummaries.sort((a, b) => b.resolutionRate.compareTo(a.resolutionRate));

    return CivicAnalyticsData(
      totalGrievances: grievances.length,
      resolvedGrievances: resolved,
      inProgressGrievances: inProgress,
      breachedGrievances: breached,
      slaComplianceRate: compliance,
      averageResolutionHours: avgHours,
      categoryCounts: catCounts,
      wardRankings: wardSummaries,
    );
  }
}
