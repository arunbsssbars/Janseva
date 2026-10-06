import 'package:flutter/material.dart';
import 'package:janseva_mobile/core/models/citizen_kyc_profile.dart';

class IdentityVerificationScreen extends StatefulWidget {
  final bool isHindi;

  const IdentityVerificationScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  final _aadhaarController = TextEditingController();
  final _nameController = TextEditingController(text: 'Aarav Patel');

  bool _isConnectingDigiLocker = false;
  CitizenKycProfile _profile = const CitizenKycProfile(
    citizenId: 'CIT-2026-9081',
    fullName: 'Aarav Patel',
    aadhaarLast4: '4892',
    aadhaarSha256Hash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    status: KycStatus.verified,
    digiLockerDocUri: 'digilocker://in.gov.uidai/aadhaar/9081',
  );

  @override
  void dispose() {
    _aadhaarController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _verifyViaDigiLocker() {
    setState(() => _isConnectingDigiLocker = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final rawInput = _aadhaarController.text.trim();
      final last4 = rawInput.length >= 4 ? rawInput.substring(rawInput.length - 4) : '7721';
      final hash = CitizenKycProfile.hashAadhaar(rawInput.isNotEmpty ? rawInput : '123456787721');

      setState(() {
        _isConnectingDigiLocker = false;
        _profile = _profile.copyWith(
          fullName: _nameController.text.trim(),
          aadhaarLast4: last4,
          aadhaarSha256Hash: hash,
          status: KycStatus.verified,
          verifiedAt: DateTime.now(),
          digiLockerDocUri: 'digilocker://in.gov.uidai/aadhaar/verified',
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isHindi
                ? 'डिजीलॉकर से पहचान सफलतापूर्वक सत्यापित हुई!'
                : 'DigiLocker identity verified successfully with tamper-proof seal!',
          ),
          backgroundColor: const Color(0xFF047857),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHi = widget.isHindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHi ? 'डिजिटल पहचान व डिजीलॉकर' : 'Digital Citizen Identity & KYC',
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
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _profile.isVerified
                      ? [const Color(0xFF065F46), const Color(0xFF059669)]
                      : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _profile.isVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _profile.isVerified
                                    ? (isHi ? 'प्रमाणित नागरिक' : 'Verified Citizen')
                                    : (isHi ? 'अपुष्ट खाता' : 'Unverified Account'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _profile.citizenId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _profile.fullName,
                    key: const Key('profile_full_name_text'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aadhaar: •••• •••• ${_profile.aadhaarLast4}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SHA-256: ${_profile.aadhaarSha256Hash.substring(0, 16)}...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // DigiLocker Mock Flow Section
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lock_person_rounded, color: Color(0xFF2563EB), size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isHi ? 'डिजीलॉकर सुरक्षा गेटवे' : 'DigiLocker Identity Gateway',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('kyc_name_field'),
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: isHi ? 'पूरा नाम (आधार कार्ड के अनुसार)' : 'Full Name (As on Aadhaar)',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('kyc_aadhaar_field'),
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    decoration: InputDecoration(
                      labelText: isHi ? '12 अंकों का आधार नंबर' : '12-digit Aadhaar Number',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      counterText: '',
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('verify_digilocker_btn'),
                      onPressed: _isConnectingDigiLocker ? null : _verifyViaDigiLocker,
                      icon: _isConnectingDigiLocker
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.cloud_done_rounded, size: 16),
                      label: Text(
                        _isConnectingDigiLocker
                            ? (isHi ? 'प्रमाणीकरण जारी...' : 'Authenticating...')
                            : (isHi ? 'डिजीलॉकर से तुरंत सत्यापित करें' : 'Verify via DigiLocker Sandbox'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
