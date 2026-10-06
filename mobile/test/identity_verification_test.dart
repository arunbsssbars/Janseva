import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janseva_mobile/features/profile/screens/identity_verification_screen.dart';

void main() {
  group('IdentityVerificationScreen AQIL & DigiLocker Flow Tests', () {
    testWidgets('renders identity profile and performs DigiLocker verification',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: IdentityVerificationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Digital Citizen Identity & KYC'), findsOneWidget);
      expect(find.text('Verified Citizen'), findsOneWidget);
      expect(find.text('CIT-2026-9081'), findsOneWidget);

      // Enter new details and verify
      await tester.enterText(find.byKey(const Key('kyc_name_field')), 'Pooja Sharma');
      await tester.enterText(find.byKey(const Key('kyc_aadhaar_field')), '987654321098');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('verify_digilocker_btn')));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_full_name_text')), findsOneWidget);
      expect(
        (tester.widget(find.byKey(const Key('profile_full_name_text'))) as Text).data,
        equals('Pooja Sharma'),
      );
      expect(find.text('Aadhaar: •••• •••• 1098'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on 320px compact viewport with 1.5x font scale',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.5),
            ),
            child: child!,
          ),
          home: const IdentityVerificationScreen(isHindi: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('डिजिटल पहचान व डिजीलॉकर'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
