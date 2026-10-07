import 'package:flutter/material.dart';
import '../../../core/models/public_works_project.dart';

class PublicWorksScreen extends StatefulWidget {
  const PublicWorksScreen({super.key});

  @override
  State<PublicWorksScreen> createState() => _PublicWorksScreenState();
}

class _PublicWorksScreenState extends State<PublicWorksScreen> {
  late List<PublicWorksProject> _projects;
  String _selectedCategory = 'All';
  String _selectedWard = 'All';

  final List<String> _categories = [
    'All',
    'Roads & Bridges',
    'Drainage Network',
    'Street Lighting',
    'Parks & Greenery',
  ];

  final List<String> _wards = [
    'All',
    'Ward 1',
    'Ward 2',
    'Ward 3',
    'Ward 4',
  ];

  @override
  void initState() {
    super.initState();
    _projects = List.from(PublicWorksProject.sampleProjects);
  }

  List<PublicWorksProject> get _filteredProjects {
    return _projects.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesWard = _selectedWard == 'All' || p.wardName.contains(_selectedWard);
      return matchesCategory && matchesWard;
    }).toList();
  }

  double get _totalAllocated =>
      _projects.fold(0.0, (sum, p) => sum + p.allocatedBudgetLakhs);

  double get _totalSpent =>
      _projects.fold(0.0, (sum, p) => sum + p.spentBudgetLakhs);

  void _showCitizenAuditDialog(PublicWorksProject project) {
    int selectedRating = 5;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.rate_review_rounded,
                              color: Color(0xFF1E3A8A),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Citizen Social Audit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  project.id,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Contractor: ${project.contractorName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const Divider(height: 24),
                      const Text(
                        'RATE EXECUTION QUALITY & IMPACT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            icon: Icon(
                              star <= selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: Colors.amber.shade600,
                              size: 32,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                selectedRating = star;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: feedbackController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Share audit observation (e.g. speed, material quality, public convenience)...',
                          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const Key('submit_audit_btn'),
                        onPressed: () {
                          setState(() {
                            final idx = _projects.indexWhere((p) => p.id == project.id);
                            if (idx != -1) {
                              final current = _projects[idx];
                              final newCount = current.auditReviewsCount + 1;
                              final newScore = double.parse(
                                ((current.citizenAuditScore * current.auditReviewsCount + selectedRating) /
                                        newCount)
                                    .toStringAsFixed(1),
                              );
                              _projects[idx] = current.copyWith(
                                citizenAuditScore: newScore,
                                auditReviewsCount: newCount,
                              );
                            }
                          });
                          Navigator.of(dialogCtx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Audit review verified and registered to public ledger!'),
                              backgroundColor: Color(0xFF059669),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Submit Verified Audit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProjects;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Public Works & Capital Budget',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Municipal Budget Scorecard Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_balance_wallet_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 180),
                              child: const Text(
                                'CAPITAL WORKS BUDGET',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            'FY 2025-26',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sanctioned Budget',
                                style: TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${_totalAllocated.toStringAsFixed(1)} L',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 32, color: Colors.white24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Disbursed / Spent',
                                style: TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${_totalSpent.toStringAsFixed(1)} L',
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _totalAllocated > 0 ? (_totalSpent / _totalAllocated).clamp(0.0, 1.0) : 0,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${((_totalSpent / (_totalAllocated > 0 ? _totalAllocated : 1)) * 100).toStringAsFixed(0)}% fund utilization rate across 4 municipal wards',
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filters Bar
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E3A8A),
                      backgroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Ward Filters Bar
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _wards.map((ward) {
                  final isSelected = _selectedWard == ward;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        ward,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0284C7),
                      backgroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (val) {
                        if (val) setState(() => _selectedWard = ward);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Project Cards List
          if (filtered.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No public works found for selected criteria.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filtered[index];
                    return _buildProjectCard(item);
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(PublicWorksProject project) {
    Color statusBg;
    Color statusText;
    switch (project.status) {
      case 'Completed':
        statusBg = const Color(0xFFDCFCE7);
        statusText = const Color(0xFF15803D);
        break;
      case 'Under Audit':
        statusBg = const Color(0xFFE0F2FE);
        statusText = const Color(0xFF0369A1);
        break;
      case 'Delayed':
        statusBg = const Color(0xFFFEE2E2);
        statusText = const Color(0xFFB91C1C);
        break;
      case 'In Progress':
      default:
        statusBg = const Color(0xFFFEF3C7);
        statusText = const Color(0xFFB45309);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                    project.tenderReference,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.title,
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
              '${project.wardName} • ${project.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 10),
            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Physical Progress',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
                Text(
                  '${project.progressPercent}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (project.progressPercent / 100).clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.progressPercent == 100
                      ? const Color(0xFF10B981)
                      : const Color(0xFF3B82F6),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            // Financials & Contractor
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Contractor:',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        project.contractorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Budget (Spent / Total):',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        '₹${project.spentBudgetLakhs} L / ₹${project.allocatedBudgetLakhs} L',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Milestone note
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF3B82F6)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    project.recentMilestone,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Social Audit & Action
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${project.citizenAuditScore} (${project.auditReviewsCount})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  key: Key('audit_btn_${project.id}'),
                  onPressed: () => _showCitizenAuditDialog(project),
                  icon: const Icon(Icons.rate_review_outlined, size: 14),
                  label: const Text('Audit Project', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A8A),
                    side: const BorderSide(color: Color(0xFF93C5FD)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
