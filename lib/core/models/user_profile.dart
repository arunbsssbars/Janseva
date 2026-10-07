import '../enums/civic_enums.dart';

class UserProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final UserRole role;
  final String wardId;
  final String locality;
  final int totalReportsFiled;
  final int totalUpvotesGiven;
  final DateTime joinedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.wardId,
    required this.locality,
    this.totalReportsFiled = 0,
    this.totalUpvotesGiven = 0,
    required this.joinedAt,
  });

  bool get isOfficer => role == UserRole.wardOfficer || role == UserRole.departmentAdmin;
  bool get isAdmin => role == UserRole.departmentAdmin || role == UserRole.superAdmin;

  UserProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    UserRole? role,
    String? wardId,
    String? locality,
    int? totalReportsFiled,
    int? totalUpvotesGiven,
    DateTime? joinedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      wardId: wardId ?? this.wardId,
      locality: locality ?? this.locality,
      totalReportsFiled: totalReportsFiled ?? this.totalReportsFiled,
      totalUpvotesGiven: totalUpvotesGiven ?? this.totalUpvotesGiven,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'role': role.code,
    'wardId': wardId,
    'locality': locality,
    'totalReportsFiled': totalReportsFiled,
    'totalUpvotesGiven': totalUpvotesGiven,
    'joinedAt': joinedAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'USR-001',
      name: json['name'] as String? ?? 'Aarav Patel',
      phoneNumber: json['phoneNumber'] as String? ?? '+91 9876543210',
      email: json['email'] as String? ?? 'aarav.patel@example.com',
      role: UserRole.fromCode(json['role'] as String?),
      wardId: json['wardId'] as String? ?? 'W-01',
      locality: json['locality'] as String? ?? 'Civil Lines, Block B',
      totalReportsFiled: json['totalReportsFiled'] as int? ?? 0,
      totalUpvotesGiven: json['totalUpvotesGiven'] as int? ?? 0,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static UserProfile defaultCitizen() => UserProfile(
    id: 'USR-CITIZEN-01',
    name: 'Aarav Patel',
    phoneNumber: '+91 98765 43210',
    email: 'aarav.patel@example.com',
    role: UserRole.citizen,
    wardId: 'W-01',
    locality: 'Civil Lines, Block B',
    totalReportsFiled: 4,
    totalUpvotesGiven: 12,
    joinedAt: DateTime.now().subtract(const Duration(days: 45)),
  );

  static UserProfile defaultOfficer() => UserProfile(
    id: 'USR-OFFICER-01',
    name: 'Sanjay Verma (Ward Officer)',
    phoneNumber: '+91 98100 11223',
    email: 'ward1.officer@janseva.gov.in',
    role: UserRole.wardOfficer,
    wardId: 'W-01',
    locality: 'Municipal Ward Office 1',
    totalReportsFiled: 0,
    totalUpvotesGiven: 0,
    joinedAt: DateTime.now().subtract(const Duration(days: 365)),
  );
}
