enum VendorLicenseStatus {
  activeValid,
  pendingRenewal,
  disputeUnderReview,
  suspended,
}

class VendorVendingZone {
  final String zoneId;
  final String zoneName;
  final String ward;
  final int totalPermittedSlots;
  final int allocatedSlots;
  final bool hasDrinkingWater;
  final bool hasWasteDisposalBin;

  const VendorVendingZone({
    required this.zoneId,
    required this.zoneName,
    required this.ward,
    required this.totalPermittedSlots,
    required this.allocatedSlots,
    this.hasDrinkingWater = true,
    this.hasWasteDisposalBin = true,
  });

  bool get isFull => allocatedSlots >= totalPermittedSlots;
}

class StreetVendorCertificate {
  final String certificateNumber;
  final String vendorName;
  final String tradeCategory; // 'Vegetables & Fruits', 'Cooked Food / Tea', 'Handicrafts'
  final String assignedZoneId;
  final String assignedSlotNumber;
  final VendorLicenseStatus status;
  final DateTime validTill;

  const StreetVendorCertificate({
    required this.certificateNumber,
    required this.vendorName,
    required this.tradeCategory,
    required this.assignedZoneId,
    required this.assignedSlotNumber,
    required this.status,
    required this.validTill,
  });
}
