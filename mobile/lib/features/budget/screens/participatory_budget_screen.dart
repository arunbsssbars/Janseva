import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/participatory_budget_item.dart';

class ParticipatoryBudgetScreen extends StatefulWidget {
  final bool isHindi;

  const ParticipatoryBudgetScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<ParticipatoryBudgetScreen> createState() => _ParticipatoryBudgetScreenState();
}

class _ParticipatoryBudgetScreenState extends State<ParticipatoryBudgetScreen> {
  late List<ParticipatoryBudgetItem> _proposals;

  @override
  void initState() {
    super.initState();
    _proposals = [
      const ParticipatoryBudgetItem(
        id: 'PBP-WRD1-01',
        title: 'Solar LED Lighting along Canal Jogging Track',
        description: 'Install 45 autonomous solar smart poles with emergency SOS push-buttons and CCTV.',
        ward: 'Ward 1 - Civil Lines',
        estimatedCostLakhs: 8.5,
        totalVotes: 342,
        hasVoted: false,
      ),
      const ParticipatoryBudgetItem(
        id: 'PBP-WRD1-02',
        title: 'Decentralized Community Composting & Waste Sorting Station',
        description: 'Equip Sector 4 neighborhood with odor-free aerobic microbial compost tumblers.',
        ward: 'Ward 1 - Civil Lines',
        estimatedCostLakhs: 4.2,
        totalVotes: 518,
        hasVoted: true,
      ),
      const ParticipatoryBudgetItem(
        id: 'PBP-WRD1-03',
        title: 'Inclusive Sensory Park & Accessible Children Playground',
        description: 'Braille tactile paving, wheelchair-accessible swings, and rubberized safety flooring.',
        ward: 'Ward 1 - Civil Lines',
        estimatedCostLakhs: 14.0,
        totalVotes: 689,
        hasVoted: false,
      ),
    ];
  }

  void _castVote(String id) {
    setState(() {
      _proposals = _proposals.map((p) {
        if (p.id == id) {
          final isVoted = !p.hasVoted;
          return p.copyWith(
            hasVoted: isVoted,
            totalVotes: isVoted ? p.totalVotes + 1 : (p.totalVotes - 1).clamp(0, 99999),
          );
        }
        return p;
      }).toList();
    });

    final target = _proposals.firstWhere((p) => p.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          target.hasVoted
              ? (widget.isHindi ? 'आपका मत दर्ज किया गया! धन्यवाद।' : 'Vote registered successfully!')
              : (widget.isHindi ? 'मत वापस लिया गया।' : 'Vote retracted.'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'नागरिक सहभागिता बजट मतदान' : 'Participatory Ward Budget',
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
            // Fund Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          isHi ? 'वार्ड 1 नागरिक बजट 2026-27' : 'Ward 1 Discretionary Fund',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '₹50 Lakhs Pool',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isHi
                        ? 'नागरिक प्रत्यक्ष मतदान द्वारा तय करते हैं कि स्थानीय विकास निधि कहाँ खर्च होगी।'
                        : 'Direct democracy in action. Vote for municipal neighborhood projects you want prioritized.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              isHi ? 'प्रस्तावित नागरिक परियोजनाएं' : 'Citizen Proposals Under Vote (${_proposals.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ..._proposals.map((item) => _buildProposalCard(item, isHi)),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalCard(ParticipatoryBudgetItem item, bool isHi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.hasVoted ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
          width: item.hasVoted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₹${item.estimatedCostLakhs.toStringAsFixed(1)}L',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.thumb_up_alt_rounded, size: 14, color: Color(0xFF2563EB)),
                  const SizedBox(width: 6),
                  Text(
                    '${item.totalVotes} ${isHi ? 'नागरिक मत' : 'votes'}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                key: Key('vote_btn_${item.id}'),
                onPressed: () => _castVote(item.id),
                icon: Icon(
                  item.hasVoted ? Icons.check_circle_rounded : Icons.how_to_vote_rounded,
                  size: 15,
                ),
                label: Text(
                  item.hasVoted
                      ? (isHi ? 'मत दिया (Voted)' : 'Voted')
                      : (isHi ? 'वोट दें (Support)' : 'Support Proposal'),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.hasVoted ? const Color(0xFF059669) : const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
