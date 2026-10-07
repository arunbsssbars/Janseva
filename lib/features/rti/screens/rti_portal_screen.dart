import 'package:flutter/material.dart';
import '../../../core/models/rti_request.dart';
import '../../../core/state/janseva_state.dart';

class RtiPortalScreen extends StatefulWidget {
  final JanSevaState? state;
  final bool isHindi;

  const RtiPortalScreen({super.key, this.state, this.isHindi = false});

  @override
  State<RtiPortalScreen> createState() => _RtiPortalScreenState();
}

class _RtiPortalScreenState extends State<RtiPortalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<RtiRequest> _filings;

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _queryController = TextEditingController();
  String _selectedDept = 'Public Works Department (PWD)';
  bool _bplExempt = false;
  bool _declarationAccepted = false;

  final List<String> _departments = [
    'Public Works Department (PWD)',
    'Health & Sanitation',
    'Town Planning & Encroachment',
    'Water & Drainage Supply',
    'Property Tax & Assessment',
    'Education & Welfare',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filings = List.from(RtiRequest.sampleRequests);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _submitRti() {
    if (!_formKey.currentState!.validate()) return;
    if (!_declarationAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the statutory citizenship declaration.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final newRequest = RtiRequest(
      id: 'RTI/MCD/2026/0${120 + _filings.length}',
      applicantName: widget.state?.currentUser.name ?? 'Verified Citizen',
      department: _selectedDept,
      subject: _subjectController.text.trim(),
      queryDetails: _queryController.text.trim(),
      bplFeeExempt: _bplExempt,
      status: 'Under Review by PIO',
      filedDate: DateTime.now(),
      statutoryDeadline: DateTime.now().add(const Duration(days: 30)),
      pioOfficerName: 'Assigned Municipal PIO',
    );

    setState(() {
      _filings.insert(0, newRequest);
      _subjectController.clear();
      _queryController.clear();
      _declarationAccepted = false;
    });

    _tabController.animateTo(0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('RTI Application ${newRequest.id} registered! 30-day statutory clock initiated.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Right to Information (RTI)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: 'My RTI Filings'),
            Tab(text: 'File New Application'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilingsList(),
          _buildNewApplicationForm(),
        ],
      ),
    );
  }

  Widget _buildFilingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filings.length,
      itemBuilder: (context, index) {
        final rti = _filings[index];
        final isDispatched = rti.status == 'Information Dispatched';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rti.id,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDispatched ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rti.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDispatched ? const Color(0xFF15803D) : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                rti.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dept: ${rti.department}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  rti.queryDetails,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.4),
                ),
              ),
              if (rti.responseSummary != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mark_email_read_outlined, size: 16, color: Color(0xFF16A34A)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rti.responseSummary!,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          '${rti.daysRemaining} days left on clock',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      'PIO: ${rti.pioOfficerName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewApplicationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.gavel_rounded, color: Color(0xFF1E40AF), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Statutory RTI Act 2005 Portal: Public authorities must respond within 30 days of application.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Target Municipal Department',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedDept,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
              items: _departments.map((d) {
                return DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 12)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDept = val);
              },
            ),
            const SizedBox(height: 14),
            const Text(
              'Subject of Information Request',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'e.g. Work orders for drainage repair in Ward 2...',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Please specify subject' : null,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 14),
            const Text(
              'Precise Details of Information Required',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _queryController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'List certified documents, date ranges, contract numbers or file references required...',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
              ),
              validator: (v) => v == null || v.trim().length < 10 ? 'Please provide detailed query (min 10 chars)' : null,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 14),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Below Poverty Line (BPL) Exemption (Fee: ₹0)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
              subtitle: const Text(
                'Exempt from statutory ₹10 application fee under Sec 7(5)',
                style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
              value: _bplExempt,
              onChanged: (val) => setState(() => _bplExempt = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'I declare that I am a citizen of India and the information sought is for bona fide public inquiry.',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
              ),
              value: _declarationAccepted,
              onChanged: (val) => setState(() => _declarationAccepted = val ?? false),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('submit_rti_btn'),
              onPressed: _submitRti,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Submit Statutory RTI Application', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
