import 'package:flutter/material.dart';
import '../../../core/models/ward.dart';
import '../../../core/models/ward_forum_post.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';

class WardForumScreen extends StatefulWidget {
  final JanSevaState state;

  const WardForumScreen({super.key, required this.state});

  @override
  State<WardForumScreen> createState() => _WardForumScreenState();
}

class _WardForumScreenState extends State<WardForumScreen> {
  String? _selectedWardId;
  ForumTopicCategory? _selectedCategory;
  bool _sortByPopular = true;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isHindi = state.isHindi;
    final currentUserId = state.currentUser.id;

    var posts = state.forumPosts.where((p) {
      if (_selectedWardId != null && p.wardId != _selectedWardId) return false;
      if (_selectedCategory != null && p.category != _selectedCategory) return false;
      return true;
    }).toList();

    if (_sortByPopular) {
      posts.sort((a, b) => b.upvotesCount.compareTo(a.upvotesCount));
    } else {
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'नागरिक वार्ड मंच' : 'Ward Community Forum',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostDialog(context, isHindi),
        backgroundColor: CivicColors.primary,
        icon: const Icon(Icons.add_comment, color: Colors.white, size: 18),
        label: Text(
          isHindi ? 'नया प्रस्ताव' : 'New Proposal',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter Bar
            _buildFilters(isHindi),

            const SizedBox(height: 12),

            // Sort & Counter Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Text(
                  '${isHindi ? "सामुदायिक प्रस्ताव" : "Community Proposals"} (${posts.length})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Text(
                      isHindi ? 'क्रमबद्ध:' : 'Sort:',
                      style: const TextStyle(fontSize: 12, color: CivicColors.textMuted),
                    ),
                    ChoiceChip(
                      label: Text(isHindi ? 'लोकप्रिय' : 'Popular', style: const TextStyle(fontSize: 11)),
                      selected: _sortByPopular,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (val) => setState(() => _sortByPopular = true),
                    ),
                    ChoiceChip(
                      label: Text(isHindi ? 'नवीनतम' : 'Recent', style: const TextStyle(fontSize: 11)),
                      selected: !_sortByPopular,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (val) => setState(() => _sortByPopular = false),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    isHindi ? 'इस श्रेणी में कोई प्रस्ताव नहीं है।' : 'No proposals found in this section.',
                    style: const TextStyle(fontSize: 13, color: CivicColors.textMuted),
                  ),
                ),
              )
            else
              ...posts.map((post) {
                final hasUpvoted = post.upvotedUserIds.contains(currentUserId);
                return _buildPostCard(post, hasUpvoted, isHindi);
              }),

            const SizedBox(height: 60), // FAB spacing
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ward scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: Text(isHindi ? 'सभी वार्ड' : 'All Wards'),
                selected: _selectedWardId == null,
                onSelected: (_) => setState(() => _selectedWardId = null),
              ),
              const SizedBox(width: 6),
              ...Ward.defaultWards().take(3).map((w) {
                final isSelected = _selectedWardId == w.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text('W-${w.wardNumber} ${w.wardName}'),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedWardId = isSelected ? null : w.id),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Category scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: Text(isHindi ? 'सभी विषय' : 'All Topics'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
              ),
              const SizedBox(width: 6),
              ...ForumTopicCategory.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(isHindi ? cat.titleHi : cat.titleEn),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = isSelected ? null : cat),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(WardForumPost post, bool hasUpvoted, bool isHindi) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: CivicColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Category chip & Ward info
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CivicColors.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isHindi ? post.category.titleHi : post.category.titleEn,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: CivicColors.primary),
                  ),
                ),
                Text(
                  '${post.wardName} • ${post.authorName}',
                  style: const TextStyle(fontSize: 11, color: CivicColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: CivicColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 12, height: 1.35, color: CivicColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Official Responder Banner
            if (post.hasOfficialResponse) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CivicColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: CivicColors.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, size: 14, color: CivicColors.success),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Official Response: ${post.officialResponderTitle ?? "Municipal Officer"}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: CivicColors.success),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.officialResponse!,
                      style: const TextStyle(fontSize: 11, color: CivicColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),

            // Footer Action Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mode_comment_outlined, size: 14, color: CivicColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentsCount} ${isHindi ? "टिप्पणियाँ" : "Comments"}',
                      style: const TextStyle(fontSize: 11, color: CivicColors.textSecondary),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => widget.state.toggleForumUpvote(post.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasUpvoted ? CivicColors.primaryContainer : CivicColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasUpvoted ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                          size: 13,
                          color: hasUpvoted ? CivicColors.primary : CivicColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.upvotesCount}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: hasUpvoted ? CivicColors.primary : CivicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, bool isHindi) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    var selectedCat = ForumTopicCategory.infrastructure;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isHindi ? 'नया सामुदायिक प्रस्ताव दर्ज करें' : 'Submit Ward Improvement Proposal',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ForumTopicCategory>(
                      initialValue: selectedCat,
                      decoration: InputDecoration(
                        labelText: isHindi ? 'विषय श्रेणी' : 'Topic Category',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: ForumTopicCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(isHindi ? cat.titleHi : cat.titleEn, style: const TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCat = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: isHindi ? 'शीर्षक' : 'Proposal Title',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: isHindi ? 'विस्तृत प्रस्ताव एवं औचित्य' : 'Detailed Proposal & Rationale',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) return;
                        final newPost = WardForumPost(
                          id: 'post-${DateTime.now().millisecondsSinceEpoch}',
                          wardId: widget.state.currentUser.wardId,
                          wardName: widget.state.currentUser.locality,
                          authorId: widget.state.currentUser.id,
                          authorName: widget.state.currentUser.name,
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                          category: selectedCat,
                          createdAt: DateTime.now(),
                          upvotedUserIds: [widget.state.currentUser.id],
                        );
                        widget.state.addForumPost(newPost);
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CivicColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(isHindi ? 'प्रस्ताव प्रकाशित करें' : 'Publish Proposal'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
