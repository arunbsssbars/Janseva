import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/utility_dispute_claim.dart';

class UtilityDisputeScreen extends StatefulWidget {
  final bool isHindi;

  const UtilityDisputeScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<UtilityDisputeScreen> createState() => _UtilityDisputeScreenState();
}

class _UtilityDisputeScreenState extends State<UtilityDisputeScreen> {
  final _consumerController = TextEditingController();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  String _selectedType = 'Property Tax';

  final List<UtilityDisputeClaim> _claims = [
    UtilityDisputeClaim(
      disputeId: 'DISP-2026-091',
      consumerNumber: 'PT-WRD14-88219',
      billType: 'Property Tax',
      billedAmount: 14850.0,
      disputedAmount: 4500.0,
      reason: 'Vacant plot assessed under commercial rate instead of residential',
      status: 'Hearing Scheduled',
      filedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    UtilityDisputeClaim(
      disputeId: 'DISP-2026-042',
      consumerNumber: 'WTR-WRD08-1102',
      billType: 'Water Tariff',
      billedAmount: 3200.0,
      disputedAmount: 2100.0,
      reason: 'Faulty mechanical meter recorded surge during dry maintenance cycle',
      status: 'Adjustment Approved',
      filedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  @override
  void dispose() {
    _consumerController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitClaim() {
    if (_consumerController.text.trim().isEmpty || _amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isHindi
                ? 'कृपया उपभोक्ता संख्या और राशि भरें।'
                : 'Please fill Consumer ID and disputed amount.',
          ),
        ),
      );
      return;
    }

    final newClaim = UtilityDisputeClaim(
      disputeId: 'DISP-2026-${_claims.length + 101}',
      consumerNumber: _consumerController.text.trim(),
      billType: _selectedType,
      billedAmount: double.tryParse(_amountController.text.trim()) ?? 1000.0,
      disputedAmount: double.tryParse(_amountController.text.trim()) ?? 1000.0,
      reason: _reasonController.text.trim().isEmpty ? 'Billed discrepancy' : _reasonController.text.trim(),
      status: 'Under Verification',
      filedAt: DateTime.now(),
    );

    setState(() {
      _claims.insert(0, newClaim);
      _consumerController.clear();
      _amountController.clear();
      _reasonController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isHindi
              ? 'विवाद दावा सफलतापूर्वक दर्ज किया गया।'
              : 'Dispute grievance registered successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'नगरपालिका कर व बिल निवारण' : 'Utility & Tax Dispute Redressal',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Information Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: Color(0xFF2563EB), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHi ? 'पारदर्शी बिलिंग मध्यस्थता' : 'Fair Billing Adjudication',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHi
                              ? 'अनुचित संपत्ति कर या जल बिल के विरुद्ध ऑनलाइन दावा दायर करें।'
                              : 'Challenge inflated assessments with instant municipal ledger review.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHi ? 'नया बिल विवाद दर्ज करें' : 'File Dispute Claim',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: isHi ? 'बिल का प्रकार' : 'Bill Type',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: ['Property Tax', 'Water Tariff', 'Trade License']
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                t,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v ?? 'Property Tax'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('consumer_number_field'),
                    controller: _consumerController,
                    decoration: InputDecoration(
                      labelText: isHi ? 'उपभोक्ता / प्रॉपर्टी खाता संख्या' : 'Consumer / Property ID',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('amount_field'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: isHi ? 'विवादित राशि (₹)' : 'Disputed Amount (₹)',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('reason_field'),
                    controller: _reasonController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: isHi ? 'आपत्ति का कारण' : 'Reason for Dispute',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('submit_claim_btn'),
                      onPressed: _submitClaim,
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text(
                        isHi ? 'दावा जमा करें' : 'Submit Dispute Claim',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Claims list
            Text(
              isHi ? 'दाखिल विवाद (Filed Claims)' : 'Previous Redressal Claims (${_claims.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            ..._claims.map((claim) => _buildClaimCard(claim, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimCard(UtilityDisputeClaim claim, bool isHi) {
    final isApproved = claim.status == 'Adjustment Approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  claim.disputeId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    claim.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${claim.billType} • ${claim.consumerNumber}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            claim.reason,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '₹${claim.disputedAmount.toStringAsFixed(0)} ${isHi ? 'विवादित' : 'disputed'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${claim.filedAt.day}/${claim.filedAt.month}/${claim.filedAt.year}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
