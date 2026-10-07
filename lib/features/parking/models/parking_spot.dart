class ParkingSpot {
  final String id;
  final String name;
  final String ward;
  final String address;
  final int totalSlots;
  final int occupiedSlots;
  final double hourlyRate;
  final bool hasEvCharging;
  final double latitude;
  final double longitude;

  const ParkingSpot({
    required this.id,
    required this.name,
    required this.ward,
    required this.address,
    required this.totalSlots,
    required this.occupiedSlots,
    required this.hourlyRate,
    required this.hasEvCharging,
    required this.latitude,
    required this.longitude,
  });

  int get availableSlots => totalSlots - occupiedSlots;
  double get occupancyRate => (occupiedSlots / totalSlots) * 100;

  bool get isFull => availableSlots <= 0;
  bool get isHighDemand => occupancyRate >= 80;
}
