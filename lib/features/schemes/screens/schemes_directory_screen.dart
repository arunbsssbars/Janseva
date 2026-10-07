import 'package:flutter/material.dart';
import '../../../core/models/civic_scheme.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class SchemesDirectoryScreen extends StatefulWidget {
  final JanSevaState state;

  const SchemesDirectoryScreen({super.key, required this.state});

  @override
  State<SchemesDirectoryScreen> createState() => _SchemesDirectoryScreenState();
}

class _SchemesDirectoryScreenState extends State<SchemesDirectoryScreen> {
  final List<CivicScheme> _allSchemes = CivicScheme.getPreloadedSchemes();
  double _annualIncomeFilter = 500000;
  bool _filterByIncome = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.state.isHindi;

    final filteredSchemes = _allSchemes.where((s) {
      if (_filterByIncome && s.maxIncomePerAnnum < _annualIncomeFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = s.title.toLowerCase().contains(q) ||
            s.titleHi.contains(q) ||
            s.category.toLowerCase().contains(q) ||
            s.department.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'कल्याणकारी योजनाएं' : 'Welfare Schemes',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Input
            TextField(
              decoration: InputDecoration(
                hintText: isHindi ? 'योजना या विभाग खोजें...' : 'Search schemes, subsidies, health...',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),

            const SizedBox(height: 16),

            // Eligibility Filter Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calculate_outlined, color: CivicColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isHindi ? 'पात्रता कैलकुलेटर (आय सीमा)' : 'Eligibility Checker (Annual Income)',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Switch(
                          value: _filterByIncome,
                          onChanged: (val) => setState(() => _filterByIncome = val),
                        ),
                      ],
                    ),
                    if (_filterByIncome) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Household Income Limit:', style: TextStyle(fontSize: 12)),
                          Text(
                            '₹${(_annualIncomeFilter / 100000).toStringAsFixed(1)} Lakh / yr',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: CivicColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _annualIncomeFilter,
                        min: 100000,
                        max: 1000000,
                        divisions: 9,
                        onChanged: (v) => setState(() => _annualIncomeFilter = v),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Schemes list header
            Text(
              '${isHindi ? "उपलब्ध योजनाएं" : "Available Schemes"} (${filteredSchemes.length})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            ...filteredSchemes.map((scheme) => _buildSchemeCard(scheme, isHindi)),

            if (filteredSchemes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No welfare schemes matching income or search criteria.'),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(CivicScheme scheme, bool isHindi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CivicColors.secondaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                scheme.category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CivicColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHindi ? scheme.titleHi : scheme.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              scheme.department,
              style: const TextStyle(fontSize: 12, color: CivicColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Text(
              isHindi ? scheme.benefitSummaryHi : scheme.benefitSummary,
              style: const TextStyle(fontSize: 13, height: 1.35, color: CivicColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              isHindi ? 'आवश्यक दस्तावेज:' : 'Required Documents:',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: scheme.requiredDocuments.map((doc) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CivicColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: CivicColors.border),
                  ),
                  child: Text(
                    doc,
                    style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Max: ₹${(scheme.maxIncomePerAnnum / 100000).toStringAsFixed(1)}L/yr',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CivicColors.textMuted),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening official portal: ${scheme.officialPortalUrl}')),
                    );
                  },
                  child: Text(isHindi ? 'आवेदन पोर्टल' : 'Apply Online'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
