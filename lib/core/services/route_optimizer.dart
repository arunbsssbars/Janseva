import 'dart:math' as math;
import '../enums/civic_enums.dart';
import '../models/grievance.dart';

class OptimizedWaypoint {
  final Grievance grievance;
  final int sequenceOrder;
  final double distanceKm;
  final int estimatedDurationMinutes;

  const OptimizedWaypoint({
    required this.grievance,
    required this.sequenceOrder,
    required this.distanceKm,
    required this.estimatedDurationMinutes,
  });
}

class RouteOptimizationResult {
  final double totalDistanceKm;
  final int estimatedTotalMinutes;
  final List<OptimizedWaypoint> waypoints;

  const RouteOptimizationResult({
    required this.totalDistanceKm,
    required this.estimatedTotalMinutes,
    required this.waypoints,
  });
}

class InspectionRouteOptimizer {
  /// Haversine distance formula between two GPS coordinates in kilometers
  static double calculateDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Optimizes route using greedy nearest-neighbor with emergency priority weighting
  static RouteOptimizationResult optimizeRoute({
    required double officerLat,
    required double officerLon,
    required List<Grievance> grievances,
  }) {
    if (grievances.isEmpty) {
      return const RouteOptimizationResult(
        totalDistanceKm: 0,
        estimatedTotalMinutes: 0,
        waypoints: [],
      );
    }

    final List<Grievance> unvisited = List.from(grievances);
    final List<OptimizedWaypoint> ordered = [];

    double currentLat = officerLat;
    double currentLon = officerLon;
    double totalDistance = 0.0;
    int totalMinutes = 0;
    int sequence = 1;

    while (unvisited.isNotEmpty) {
      int bestIndex = 0;
      double bestScore = double.infinity;
      double bestDist = 0.0;

      for (int i = 0; i < unvisited.length; i++) {
        final g = unvisited[i];
        final dist = calculateDistanceKm(
          lat1: currentLat,
          lon1: currentLon,
          lat2: g.latitude,
          lon2: g.longitude,
        );

        // Priority weighting: Emergency issues score 4x closer, High issues score 2x closer
        double weight = 1.0;
        if (g.priority == GrievancePriority.emergency) {
          weight = 0.25;
        } else if (g.priority == GrievancePriority.high) {
          weight = 0.50;
        }

        final score = dist * weight;
        if (score < bestScore) {
          bestScore = score;
          bestIndex = i;
          bestDist = dist;
        }
      }

      final chosen = unvisited.removeAt(bestIndex);
      totalDistance += bestDist;

      // Estimate travel (avg 25 km/h urban speed) + 15 mins inspection per site
      final travelMins = ((bestDist / 25.0) * 60).round();
      final stopMins = travelMins + 15;
      totalMinutes += stopMins;

      ordered.add(
        OptimizedWaypoint(
          grievance: chosen,
          sequenceOrder: sequence++,
          distanceKm: double.parse(bestDist.toStringAsFixed(2)),
          estimatedDurationMinutes: stopMins,
        ),
      );

      currentLat = chosen.latitude;
      currentLon = chosen.longitude;
    }

    return RouteOptimizationResult(
      totalDistanceKm: double.parse(totalDistance.toStringAsFixed(1)),
      estimatedTotalMinutes: totalMinutes,
      waypoints: ordered,
    );
  }
}
