import 'package:flutter/material.dart';
import '../../../core/enums/civic_enums.dart';
import '../../../core/models/ward.dart';
import '../../../core/services/ai_classifier.dart';
import '../../../core/state/janseva_state.dart';
import '../../../core/services/duplicate_detector.dart';
import '../../../core/theme/civic_colors.dart';
import '../../../core/widgets/civic_widgets.dart';
import '../../community/widgets/duplicate_warning_dialog.dart';

class ReportGrievanceScreen extends StatefulWidget {
  final JanSevaState state;

  const ReportGrievanceScreen({super.key, required this.state});

  @override
  State<ReportGrievanceScreen> createState() => _ReportGrievanceScreenState();
}

class _ReportGrievanceScreenState extends State<ReportGrievanceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController(text: 'Near Main Market Crossroad');
  final _landmarkController = TextEditingController();

  GrievanceCategory _selectedCategory = GrievanceCategory.roadsAndPotholes;
  GrievancePriority _selectedPriority = GrievancePriority.medium;
  Ward? _selectedWard;
  final List<String> _attachedPhotos = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.state.wards.isNotEmpty) {
      _selectedWard = widget.state.wards.first;
    }
    _titleController.addListener(_onTextChange);
    _descController.addListener(_onTextChange);
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChange);
    _descController.removeListener(_onTextChange);
    _titleController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _addSamplePhoto() {
    setState(() {
      final sampleUrl = 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=600&t=${DateTime.now().millisecondsSinceEpoch}';
      _attachedPhotos.add(sampleUrl);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _attachedPhotos.removeAt(index);
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWard == null) return;

    // Check for potential duplicate reports
    final duplicates = DuplicateGrievanceDetector.findPotentialDuplicates(
      activeGrievances: widget.state.grievances,
      newTitle: _titleController.text.trim(),
      newDescription: _descController.text.trim(),
      newCategory: _selectedCategory,
      newWardId: _selectedWard!.id,
    );

    if (duplicates.isNotEmpty) {
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => DuplicateWarningDialog(
          matches: duplicates,
          isHindi: widget.state.isHindi,
          onProceedAnyway: () => Navigator.pop(dialogCtx, true),
          onUpvoteExisting: (id) async {
            await widget.state.upvote(id);
            if (dialogCtx.mounted) {
              Navigator.pop(dialogCtx, false);
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: CivicColors.primary,
                  content: Text('Upvoted existing report! Priority escalated.'),
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      );

      if (shouldProceed != true) return;
    }

    setState(() => _isSubmitting = true);

    try {
      final created = await widget.state.createGrievance(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        wardId: _selectedWard!.id,
        wardName: _selectedWard!.wardName,
        address: _addressController.text.trim(),
        landmark: _landmarkController.text.trim(),
        latitude: 28.6139,
        longitude: 77.2090,
        photoUrls: _attachedPhotos,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CivicColors.success,
            content: Text(
              widget.state.isOnline
                  ? 'Grievance #${created.id} submitted successfully!'
                  : 'Grievance #${created.id} saved offline. Will sync when online.',
            ),
          ),
        );
        Navigator.pop(context, created);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.state.isHindi;

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'शिकायत दर्ज करें' : 'File a Civic Grievance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Offline Alert Banner if offline
              if (!widget.state.isOnline)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CivicColors.warningContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CivicColors.warning.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: CivicColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isHindi
                              ? 'ऑफ़लाइन मोड: रिपोर्ट डिवाइस पर सहेज ली जाएगी।'
                              : 'Offline Mode: Your report will be safely queued locally.',
                          style: const TextStyle(
                            color: CivicColors.warning,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Category Selector Header
              Text(
                isHindi ? 'समस्या की श्रेणी चुनें' : 'Select Grievance Category',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GrievanceCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      isHindi ? cat.displayNameHi : cat.displayNameEn,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : CivicColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: CivicColors.primary,
                    backgroundColor: CivicColors.surfaceVariant,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Title Field
              TextFormField(
                controller: _titleController,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: isHindi ? 'शिकायत का संक्षिप्त शीर्षक *' : 'Grievance Title *',
                  hintText: isHindi ? 'उदा. मुख्य सड़क पर गहरा गड्ढा' : 'e.g. Deep pothole on 4th Main',
                  counterText: '',
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 5) {
                    return isHindi
                        ? 'कृपया कम से कम 5 अक्षरों का शीर्षक लिखें'
                        : 'Please provide a title with at least 5 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Real-time AI Classification Suggestion
              Builder(builder: (context) {
                final combinedText = '${_titleController.text} ${_descController.text}'.trim();
                if (combinedText.length < 5) return const SizedBox.shrink();

                final aiResult = AiCivicClassifier.classify(combinedText);
                if (aiResult.confidence < 0.60) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CivicColors.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CivicColors.primary.withValues(alpha: 0.3)),
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, color: CivicColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                isHindi ? 'एआई स्मार्ट सुझाव' : 'AI Smart Suggestion',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: CivicColors.primary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(aiResult.confidence * 100).toInt()}% Match',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CivicColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Suggested: ${isHindi ? aiResult.category.displayNameHi : aiResult.category.displayNameEn} • ${isHindi ? aiResult.departmentNameHi : aiResult.departmentName}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (aiResult.isHazardDetected)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            isHindi ? '⚠ सुरक्षा चेतावनी: उच्च प्राथमिकता अनुशंसित' : '⚠ Hazard Detected: Elevated Priority Recommended',
                            style: const TextStyle(fontSize: 10, color: CivicColors.error, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = aiResult.category;
                              _selectedPriority = aiResult.priority;
                            });
                          },
                          icon: const Icon(Icons.check, size: 14),
                          label: Text(
                            isHindi ? 'सुझाव लागू करें' : 'Apply AI Suggestion',
                            style: const TextStyle(fontSize: 11),
                          ),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: isHindi ? 'विस्तृत विवरण *' : 'Detailed Description *',
                  hintText: isHindi
                      ? 'समस्या की स्थिति, प्रभाव और समय बताएं'
                      : 'Describe the issue, hazard level, and how long it has persisted',
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 10) {
                    return isHindi
                        ? 'कृपया कम से कम 10 अक्षरों का विवरण लिखें'
                        : 'Please write a description of at least 10 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Ward Dropdown
              DropdownButtonFormField<Ward>(
                initialValue: _selectedWard,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: isHindi ? 'वार्ड चुनें *' : 'Select Municipal Ward *',
                ),
                items: widget.state.wards.map((ward) {
                  return DropdownMenuItem<Ward>(
                    value: ward,
                    child: Text(
                      'Ward ${ward.wardNumber}: ${ward.wardName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (ward) {
                  if (ward != null) setState(() => _selectedWard = ward);
                },
              ),

              const SizedBox(height: 16),

              // Address & Landmark
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: isHindi ? 'स्थान / सड़क का नाम *' : 'Street Address / Locality *',
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Address is required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _landmarkController,
                decoration: InputDecoration(
                  labelText: isHindi ? 'निकटतम लैंडमार्क (वैकल्पिक)' : 'Nearest Landmark (Optional)',
                  hintText: isHindi ? 'उदा. प्राथमिक विद्यालय के सामने' : 'e.g. Opposite Community Hall',
                  prefixIcon: const Icon(Icons.near_me_outlined, size: 20),
                ),
              ),

              const SizedBox(height: 16),

              // Priority Selector
              Text(
                isHindi ? 'गंभीरता / प्राथमिकता' : 'Severity / Urgency',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: GrievancePriority.values.map((p) {
                  final isSelected = p == _selectedPriority;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPriority = p),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? CivicColors.primary : CivicColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : CivicColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Photo Attachment Section
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isHindi ? 'साक्ष्य फोटो संलग्न करें' : 'Attach Photo Evidence',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _attachedPhotos.length < 3 ? _addSamplePhoto : null,
                    icon: const Icon(Icons.add_a_photo, size: 18),
                    label: Text(isHindi ? 'फोटो जोड़ें' : 'Add Photo'),
                  ),
                ],
              ),
              if (_attachedPhotos.isNotEmpty)
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _attachedPhotos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CivicColors.surfaceVariant,
                              border: Border.all(color: CivicColors.border),
                            ),
                            child: const Center(
                              child: Icon(Icons.image, size: 36, color: CivicColors.primary),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              const SizedBox(height: 28),

              // Submit Action Button (AQIL min 48px height)
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isHindi ? 'शिकायत प्रस्तुत करें' : 'Submit Grievance',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
