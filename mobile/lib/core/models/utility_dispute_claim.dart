class UtilityDisputeClaim {
  final String disputeId;
  final String consumerNumber;
  final String billType; // 'Property Tax', 'Water Tariff', 'Trade License'
  final double billedAmount;
  final double disputedAmount;
  final String reason;
  final String status; // 'Under Verification', 'Hearing Scheduled', 'Adjustment Approved'
  final DateTime filedAt;

  const UtilityDisputeClaim({
    required this.disputeId,
    required this.consumerNumber,
    required this.billType,
    required this.billedAmount,
    required this.disputedAmount,
    required this.reason,
    required this.status,
    required this.filedAt,
  });
}
