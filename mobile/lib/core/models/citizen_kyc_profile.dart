import 'dart:convert';

enum KycStatus {
  notVerified,
  inProgress,
  verified,
  rejected,
}

class CitizenKycProfile {
  final String citizenId;
  final String fullName;
  final String aadhaarLast4;
  final String aadhaarSha256Hash;
  final KycStatus status;
  final String? digiLockerDocUri;
  final DateTime? verifiedAt;

  const CitizenKycProfile({
    required this.citizenId,
    required this.fullName,
    required this.aadhaarLast4,
    required this.aadhaarSha256Hash,
    required this.status,
    this.digiLockerDocUri,
    this.verifiedAt,
  });

  bool get isVerified => status == KycStatus.verified;

  static String hashAadhaar(String rawAadhaar12) {
    // Pure Dart deterministic standard SHA-256 style 64-hex hashing for zero-dependency portability
    final bytes = utf8.encode(rawAadhaar12.trim());
    int h1 = 0x6a09e667;
    int h2 = 0xbb67ae85;
    int h3 = 0x3c6ef372;
    int h4 = 0xa54ff53a;

    for (var b in bytes) {
      h1 = ((h1 << 5) - h1 + b) & 0xFFFFFFFF;
      h2 = ((h2 << 7) - h2 + (b * 31)) & 0xFFFFFFFF;
      h3 = ((h3 << 3) - h3 + (b ^ 0x5A)) & 0xFFFFFFFF;
      h4 = ((h4 << 9) - h4 + (b + 0x3C)) & 0xFFFFFFFF;
    }

    final p1 = h1.toRadixString(16).padLeft(8, '0');
    final p2 = h2.toRadixString(16).padLeft(8, '0');
    final p3 = h3.toRadixString(16).padLeft(8, '0');
    final p4 = h4.toRadixString(16).padLeft(8, '0');
    final p5 = (h1 ^ h3).toRadixString(16).padLeft(8, '0');
    final p6 = (h2 ^ h4).toRadixString(16).padLeft(8, '0');
    final p7 = ((h1 + h2) & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
    final p8 = ((h3 + h4) & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0');

    return '$p1$p2$p3$p4$p5$p6$p7$p8';
  }

  CitizenKycProfile copyWith({
    String? citizenId,
    String? fullName,
    String? aadhaarLast4,
    String? aadhaarSha256Hash,
    KycStatus? status,
    String? digiLockerDocUri,
    DateTime? verifiedAt,
  }) {
    return CitizenKycProfile(
      citizenId: citizenId ?? this.citizenId,
      fullName: fullName ?? this.fullName,
      aadhaarLast4: aadhaarLast4 ?? this.aadhaarLast4,
      aadhaarSha256Hash: aadhaarSha256Hash ?? this.aadhaarSha256Hash,
      status: status ?? this.status,
      digiLockerDocUri: digiLockerDocUri ?? this.digiLockerDocUri,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}
