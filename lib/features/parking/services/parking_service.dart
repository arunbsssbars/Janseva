import '../models/parking_spot.dart';

class ParkingService {
  static List<ParkingSpot> getLiveParkingSpots() {
    return [
      const ParkingSpot(
        id: 'PRK-01',
        name: 'Metro Multi-Level Automated Parking',
        ward: 'Ward 1 - Civil Lines',
        address: 'MG Road Metro Station Interchange',
        totalSlots: 150,
        occupiedSlots: 122,
        hourlyRate: 30.0,
        hasEvCharging: true,
        latitude: 28.6139,
        longitude: 77.2090,
      ),
      const ParkingSpot(
        id: 'PRK-02',
        name: 'Gandhi Nagar Central Market Plaza',
        ward: 'Ward 2 - Gandhi Nagar',
        address: 'Block B Commercial Complex',
        totalSlots: 80,
        occupiedSlots: 76,
        hourlyRate: 20.0,
        hasEvCharging: false,
        latitude: 28.6150,
        longitude: 77.2100,
      ),
      const ParkingSpot(
        id: 'PRK-03',
        name: 'Industrial Area Logistics Hub Lot',
        ward: 'Ward 3 - Industrial Area',
        address: 'Sector 5 Heavy Commercial Spine',
        totalSlots: 200,
        occupiedSlots: 95,
        hourlyRate: 15.0,
        hasEvCharging: true,
        latitude: 28.6180,
        longitude: 77.2150,
      ),
      const ParkingSpot(
        id: 'PRK-04',
        name: 'Model Town Community Sports Center',
        ward: 'Ward 4 - Model Town',
        address: 'Park Avenue, Near Ring Road',
        totalSlots: 60,
        occupiedSlots: 18,
        hourlyRate: 20.0,
        hasEvCharging: true,
        latitude: 28.6200,
        longitude: 77.2180,
      ),
    ];
  }
}
