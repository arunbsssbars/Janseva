import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/govt_machinery_registry.dart';
import '../../../core/services/native_channel_launcher.dart';
import '../../../core/theme/civic_colors.dart';

/// Screen presenting 20 Real-Life Civic Grievance & Government Machinery Integrations.
/// Enables citizens to access statutory acts, competent authorities, penalties,
/// and generate formal legal petitions ready for filing and native dispatch.
class GovtMachineryHubScreen extends StatefulWidget {
  final bool isHindi;

  const GovtMachineryHubScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<GovtMachineryHubScreen> createState() => _GovtMachineryHubScreenState();
}

class _GovtMachineryHubScreenState extends State<GovtMachineryHubScreen> {
  late final List<CivicCaseItem> _allCases;
  CivicMachineryCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allCases = GovtMachineryRegistry.getAllCases();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CivicCaseItem> get _filteredCases {
    return _allCases.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesCaseNum = item.caseNumber.toString() == query;
        final matchesTitleEn = item.titleEn.toLowerCase().contains(query);
        final matchesTitleHi = item.titleHi.toLowerCase().contains(query);
        final matchesAct = item.statutoryAct.toLowerCase().contains(query);
        final matchesAuthorityEn = item.authorityEn.toLowerCase().contains(query);
        final matchesAuthorityHi = item.authorityHi.toLowerCase().contains(query);
        final matchesSummaryEn = item.summaryEn.toLowerCase().contains(query);
        final matchesSummaryHi = item.summaryHi.toLowerCase().contains(query);

        return matchesCaseNum ||
            matchesTitleEn ||
            matchesTitleHi ||
            matchesAct ||
            matchesAuthorityEn ||
            matchesAuthorityHi ||
            matchesSummaryEn ||
            matchesSummaryHi;
      }
      return true;
    }).toList();
  }

  void _showPetitionModal(BuildContext context, CivicCaseItem item) {
    final petitionText = item.petitionGenerator();
    final isHi = widget.isHindi;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.88,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CivicColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${item.caseNumber.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHi ? item.titleHi : item.titleEn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CivicColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.statutoryAct,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CivicColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                      tooltip: isHi ? 'बंद करें' : 'Close',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Petition Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: SelectableText(
                      petitionText,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        height: 1.45,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CivicColors.primary,
                        minimumSize: const Size(100, 44),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(isHi ? 'कॉपी करें' : 'Copy Dossier'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: petitionText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isHi
                                  ? 'याचिका क्लिपबोर्ड में कॉपी हो गई है!'
                                  : 'Statutory petition copied to clipboard!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 44),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text(isHi ? 'व्हाट्सएप भेजें' : 'WhatsApp'),
                      onPressed: () async {
                        await NativeChannelLauncher.sendWhatsAppComplaint(
                          message: petitionText,
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CivicColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(110, 44),
                      ),
                      icon: const Icon(Icons.email_outlined, size: 16),
                      label: Text(isHi ? 'ईमेल भेजें' : 'Email Notice'),
                      onPressed: () async {
                        await NativeChannelLauncher.sendEmailPetition(
                          recipientEmail: 'nodal.officer@gov.in',
                          subject: '[Statutory Docket] ${item.titleEn} - Case #${item.caseNumber}',
                          body: petitionText,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(CivicMachineryCategory cat) {
    switch (cat) {
      case CivicMachineryCategory.roadsAndInfra:
        return Icons.edit_road_rounded;
      case CivicMachineryCategory.waterAndHealth:
        return Icons.water_drop_rounded;
      case CivicMachineryCategory.powerAndUtilities:
        return Icons.electric_bolt_rounded;
      case CivicMachineryCategory.environmentAndAir:
        return Icons.eco_rounded;
      case CivicMachineryCategory.socialWelfareAndSafety:
        return Icons.shield_rounded;
      case CivicMachineryCategory.revenueAndTransparency:
        return Icons.account_balance_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;
    final cases = _filteredCases;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'सरकारी मशीनरी (20 मामले)' : 'Civic Machinery Hub (20 Cases)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: isHi ? 'कानूनी अधिकार मार्गदर्शिका' : 'Statutory Redressal Guide',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.gavel_rounded, color: CivicColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isHi ? 'नागरिक कानूनी सशक्तिकरण' : 'Citizen Statutory Power',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    isHi
                      ? 'यह हब भारत के वास्तविक प्रशासनिक तंत्र (पीडब्ल्यूडी, जल बोर्ड, डिस्कॉम, एनजीटी, धारा 133 सीआरपीसी/152 बीएनएसएस, आरटीआई) के अंतर्गत 20 प्रमुख नागरिक समस्याओं को सीधे जोड़ता है।\n\nप्रत्येक मामले में संबंधित कानून, सक्षम प्राधिकारी, जुर्माने की धारा एवं एक-क्लिक कानूनी याचिका जनरेटर उपलब्ध है।'
                      : 'This hub directly connects 20 major everyday civic failure points to official Indian administrative machinery (PWD DLP, Jal Board BIS 10500, DISCOM SERC, NGT SWM 2016, Sec 133 CrPC / Sec 152 BNSS, RTPS, and RTI Act 2005).\n\nEach case provides statutory act citations, competent authorities, enforceable penalty clauses, and pre-formatted legal petitions.',
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(isHi ? 'ठीक है' : 'Understood'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header search & stats bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: isHi
                        ? 'कानून, विभाग, मामला संख्या या समस्या खोजें...'
                        : 'Search by case #, act, authority, or issue...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 10),

                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(isHi ? 'सभी 20 मामले' : 'All 20 Cases'),
                          selected: _selectedCategory == null,
                          onSelected: (_) => setState(() => _selectedCategory = null),
                        ),
                      ),
                      ...CivicMachineryCategory.values.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            avatar: Icon(_getCategoryIcon(cat), size: 16),
                            label: Text(isHi ? cat.titleHi : cat.titleEn),
                            selected: _selectedCategory == cat,
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Results count
                Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        isHi
                            ? 'उपलब्ध: ${cases.length} / ${_allCases.length} वैधानिक मामले'
                            : 'Showing ${cases.length} of ${_allCases.length} statutory civic cases',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Cases List
          Expanded(
            child: cases.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            isHi ? 'कोई मामला नहीं मिला' : 'No matching cases found',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isHi
                                ? 'कृपया अलग शब्द या फ़िल्टर का उपयोग करें।'
                                : 'Try searching for keywords like "PWD", "Water", "Tree", or "RTI".',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: cases.length,
                    itemBuilder: (context, index) {
                      final item = cases[index];
                      return _buildCaseCard(context, item, isHi);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, CivicCaseItem item, bool isHi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Case number + Category
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CivicColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CASE #${item.caseNumber.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon(item.category), size: 14, color: CivicColors.primaryDark),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isHi ? item.category.titleHi : item.category.titleEn,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Main Title
            Text(
              isHi ? item.titleHi : item.titleEn,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CivicColors.textPrimary,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isHi ? item.titleEn : item.titleHi,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 10),

            // Statutory Act Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gavel_rounded, size: 15, color: Color(0xFF1D4ED8)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.statutoryAct,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Responsible Authority
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_balance_outlined, size: 15, color: Color(0xFF475569)),
                const SizedBox(width: 6),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: isHi ? 'सक्षम प्राधिकारी: ' : 'Competent Authority: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      children: [
                        TextSpan(
                          text: isHi ? item.authorityHi : item.authorityEn,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Summary description
            Text(
              isHi ? item.summaryHi : item.summaryEn,
              style: const TextStyle(fontSize: 13, height: 1.35, color: Color(0xFF475569)),
            ),

            const SizedBox(height: 10),

            // Relief / Penalty Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFB45309)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: isHi ? 'वैधानिक राहत / जुर्माना: ' : 'Statutory Relief / Penalty: ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                        children: [
                          TextSpan(
                            text: isHi ? item.penaltyOrReliefHi : item.penaltyOrReliefEn,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF78350F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Call to Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CivicColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showPetitionModal(context, item),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description_outlined, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isHi ? 'कानूनी याचिका एवं डोजियर तैयार करें' : 'Generate Legal Petition & Dossier',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
