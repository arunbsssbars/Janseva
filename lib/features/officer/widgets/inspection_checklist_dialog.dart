import 'package:flutter/material.dart';
import '../../../core/models/grievance.dart';
import '../../../core/theme/civic_colors.dart';

class InspectionAuditRecord {
  final bool isGpsLocationVerified;
  final bool isQualityCompliant;
  final bool isDebrisCleared;
  final String contractorOrCrewId;
  final String officerNotes;

  const InspectionAuditRecord({
    required this.isGpsLocationVerified,
    required this.isQualityCompliant,
    required this.isDebrisCleared,
    required this.contractorOrCrewId,
    required this.officerNotes,
  });

  bool get isComplete =>
      isGpsLocationVerified &&
      isQualityCompliant &&
      isDebrisCleared &&
      contractorOrCrewId.trim().isNotEmpty;
}

class InspectionChecklistDialog extends StatefulWidget {
  final Grievance grievance;
  final bool isHindi;
  final ValueChanged<InspectionAuditRecord> onAuditApproved;

  const InspectionChecklistDialog({
    super.key,
    required this.grievance,
    required this.isHindi,
    required this.onAuditApproved,
  });

  @override
  State<InspectionChecklistDialog> createState() => _InspectionChecklistDialogState();
}

class _InspectionChecklistDialogState extends State<InspectionChecklistDialog> {
  bool _gpsVerified = true;
  bool _qualityCompliant = false;
  bool _debrisCleared = false;
  final _crewIdController = TextEditingController();
  final _notesController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _crewIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final crewId = _crewIdController.text.trim();
    if (!_gpsVerified || !_qualityCompliant || !_debrisCleared || crewId.isEmpty) {
      setState(() {
        _errorMessage = widget.isHindi
            ? 'कृपया सभी अनिवार्य चेकलिस्ट आइटम और ठेकेदार आईडी भरें'
            : 'Please complete all audit items & enter Contractor/Crew ID';
      });
      return;
    }

    final record = InspectionAuditRecord(
      isGpsLocationVerified: _gpsVerified,
      isQualityCompliant: _qualityCompliant,
      isDebrisCleared: _debrisCleared,
      contractorOrCrewId: crewId,
      officerNotes: _notesController.text.trim(),
    );

    widget.onAuditApproved(record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.isHindi;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.assignment_turned_in, color: CivicColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isHindi ? 'कार्य पूर्णता निरीक्षण' : 'Field Inspection Audit',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: CivicColors.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.grievance.id,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CivicColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                widget.grievance.title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CivicColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Divider(height: 20, color: CivicColors.border),

              // Checklist Items
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _gpsVerified,
                onChanged: (val) => setState(() => _gpsVerified = val ?? false),
                title: Text(
                  isHindi ? '1. कार्य स्थल पर जीपीएस उपस्थिति सत्यापित' : '1. Physical site verified with GPS lock',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${widget.grievance.latitude.toStringAsFixed(4)}, ${widget.grievance.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 10, color: CivicColors.textMuted),
                ),
              ),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _qualityCompliant,
                onChanged: (val) => setState(() => _qualityCompliant = val ?? false),
                title: Text(
                  isHindi ? '2. निर्माण/सफाई गुणवत्ता मानकों के अनुरूप' : '2. Work compliant with municipal standards',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _debrisCleared,
                onChanged: (val) => setState(() => _debrisCleared = val ?? false),
                title: Text(
                  isHindi ? '3. मलबा व अवशेष सामग्री मार्ग से हटाई गई' : '3. Debris & surplus material cleared from path',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),

              // Contractor / Crew ID field
              TextField(
                controller: _crewIdController,
                decoration: InputDecoration(
                  labelText: isHindi ? 'ठेकेदार / एजेंसी आईडी *' : 'Contractor / Crew Team ID *',
                  hintText: 'e.g. PWD-CREW-402 / SWM-G-08',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // Notes
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: isHindi ? 'अधिकारी निरीक्षण टिप्पणी' : 'Officer Inspection Notes',
                  hintText: isHindi ? 'कार्य से संबंधित कोई विशेष विवरण' : 'Optional notes on materials used or warranty',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: const OutlineInputBorder(),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 11, color: CivicColors.error, fontWeight: FontWeight.bold),
                ),
              ],

              const SizedBox(height: 14),

              // Actions
              ElevatedButton.icon(
                onPressed: _validateAndSubmit,
                icon: const Icon(Icons.check_circle, size: 16),
                label: Text(
                  isHindi ? 'प्रमाणित करें व बंद करें' : 'Approve & Mark Resolved',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CivicColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
