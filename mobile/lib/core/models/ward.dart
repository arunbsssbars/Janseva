class Ward {
  final String id;
  final int wardNumber;
  final String wardName;
  final String zone;
  final String officerName;
  final String officerPhone;
  final String officerEmail;

  const Ward({
    required this.id,
    required this.wardNumber,
    required this.wardName,
    required this.zone,
    required this.officerName,
    required this.officerPhone,
    required this.officerEmail,
  });

  String get displayName => 'Ward $wardNumber - $wardName ($zone)';

  Map<String, dynamic> toJson() => {
    'id': id,
    'wardNumber': wardNumber,
    'wardName': wardName,
    'zone': zone,
    'officerName': officerName,
    'officerPhone': officerPhone,
    'officerEmail': officerEmail,
  };

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'] as String? ?? 'W-01',
      wardNumber: json['wardNumber'] as int? ?? 1,
      wardName: json['wardName'] as String? ?? 'Central Ward',
      zone: json['zone'] as String? ?? 'North Zone',
      officerName: json['officerName'] as String? ?? 'Shri Rajesh Sharma',
      officerPhone: json['officerPhone'] as String? ?? '+91 98765 43210',
      officerEmail: json['officerEmail'] as String? ?? 'ward1@janseva.gov.in',
    );
  }

  static List<Ward> defaultWards() => const [
    Ward(
      id: 'W-01',
      wardNumber: 1,
      wardName: 'Civil Lines',
      zone: 'Central Zone',
      officerName: 'Sanjay Verma',
      officerPhone: '+91 98100 11223',
      officerEmail: 'ward1.officer@janseva.gov.in',
    ),
    Ward(
      id: 'W-02',
      wardNumber: 2,
      wardName: 'Gandhi Nagar',
      zone: 'East Zone',
      officerName: 'Anita Mehra',
      officerPhone: '+91 98100 22334',
      officerEmail: 'ward2.officer@janseva.gov.in',
    ),
    Ward(
      id: 'W-03',
      wardNumber: 3,
      wardName: 'Industrial Area Phase 1',
      zone: 'South Zone',
      officerName: 'Vikram Joshi',
      officerPhone: '+91 98100 33445',
      officerEmail: 'ward3.officer@janseva.gov.in',
    ),
    Ward(
      id: 'W-04',
      wardNumber: 4,
      wardName: 'Model Town',
      zone: 'North Zone',
      officerName: 'Priya Kulkarni',
      officerPhone: '+91 98100 44556',
      officerEmail: 'ward4.officer@janseva.gov.in',
    ),
    Ward(
      id: 'W-05',
      wardNumber: 5,
      wardName: 'Old Market & Bus Stand',
      zone: 'West Zone',
      officerName: 'Harish Rawat',
      officerPhone: '+91 98100 55667',
      officerEmail: 'ward5.officer@janseva.gov.in',
    ),
  ];
}
