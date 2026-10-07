enum AnimalCondition {
  injured,
  rabiesSuspect,
  abandonedPup,
  trapped,
  aggressive,
}

enum RescueUrgency {
  immediateCritical, // < 1 hour
  urgent, // < 4 hours
  scheduled, // standard day run
}

class AnimalRescueReport {
  final String reportId;
  final String species; // Dog, Cat, Cattle, Monkey, Bird
  final AnimalCondition condition;
  final RescueUrgency urgency;
  final String locationAddress;
  final String ward;
  final String reporterContact;
  final String status; // 'Dispatched Ambulance', 'Admitted to Shelter', 'Treated & Released'
  final DateTime reportedAt;

  const AnimalRescueReport({
    required this.reportId,
    required this.species,
    required this.condition,
    required this.urgency,
    required this.locationAddress,
    required this.ward,
    required this.reporterContact,
    required this.status,
    required this.reportedAt,
  });
}
