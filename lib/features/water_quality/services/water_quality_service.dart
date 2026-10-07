import '../models/water_quality_node.dart';

class WaterQualityService {
  static List<WaterQualityNode> getLiveNodes() {
    return [
      WaterQualityNode(
        id: 'WTR-01',
        location: 'Civil Lines Overhead Reservoir Tank #2',
        ward: 'Ward 1 - Civil Lines',
        phLevel: 7.2,
        tds: 180,
        residualChlorine: 0.45,
        turbidity: 0.8,
        testedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      WaterQualityNode(
        id: 'WTR-02',
        location: 'Gandhi Nagar Community Booster Station',
        ward: 'Ward 2 - Gandhi Nagar',
        phLevel: 7.6,
        tds: 260,
        residualChlorine: 0.30,
        turbidity: 1.4,
        testedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      WaterQualityNode(
        id: 'WTR-03',
        location: 'Industrial Spine Effluent Proximity Well',
        ward: 'Ward 3 - Industrial Area',
        phLevel: 8.9,
        tds: 680,
        residualChlorine: 0.05,
        turbidity: 6.2,
        testedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      WaterQualityNode(
        id: 'WTR-04',
        location: 'Model Town Secondary Distribution Sump',
        ward: 'Ward 4 - Model Town',
        phLevel: 7.4,
        tds: 210,
        residualChlorine: 0.40,
        turbidity: 1.1,
        testedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}
