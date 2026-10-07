import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/govt_channel.dart';
import '../models/grievance.dart';

class NativeChannelLauncher {
  /// Opens device phone dialer with pre-dialed number
  static Future<bool> dialHelpline(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('dialHelpline error: $e');
    }
    return false;
  }

  /// Opens WhatsApp with formatted civic complaint pre-filled
  static Future<bool> sendWhatsAppComplaint({
    String? phone,
    required String message,
  }) async {
    final cleanPhone = phone != null ? phone.replaceAll(RegExp(r'[^0-9]'), '') : '';
    final urlString = cleanPhone.isNotEmpty
        ? 'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}'
        : 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(urlString);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('sendWhatsAppComplaint error: $e');
      return false;
    }
  }

  /// Opens default email client with official formal representation
  static Future<bool> sendEmailPetition({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    try {
      return await launchUrl(uri);
    } catch (e) {
      debugPrint('sendEmailPetition error: $e');
      return false;
    }
  }

  /// Opens Twitter / X with pre-composed public escalation tagging official handles
  static Future<bool> tweetEscalation({required String tweetText}) async {
    final uri = Uri.parse('https://twitter.com/intent/tweet?text=${Uri.encodeComponent(tweetText)}');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('tweetEscalation error: $e');
      return false;
    }
  }

  /// Opens the official government portal URL in browser
  static Future<bool> openOfficialPortal(GovtPortalType portal) async {
    String url;
    switch (portal) {
      case GovtPortalType.cpgrams:
        url = 'https://pgportal.gov.in';
        break;
      case GovtPortalType.stateJanSunwai:
        url = 'https://jansunwai.up.nic.in';
        break;
      case GovtPortalType.swachhata:
        url = 'https://swachhbharaturban.gov.in';
        break;
      case GovtPortalType.discomPower:
        url = 'https://powermin.gov.in';
        break;
      case GovtPortalType.jalBoard:
        url = 'https://delhijalboard.nic.in';
        break;
      case GovtPortalType.municipal311:
        url = 'https://mcdonline.nic.in';
        break;
    }

    final uri = Uri.parse(url);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('openOfficialPortal error: $e');
      return false;
    }
  }

  /// Copies text to system clipboard and presents confirmation snackbar
  static Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String? successMessage,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage ?? 'Copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Builds standardized citizen grievance text for messaging and dossiers
  static String buildWhatsAppMessage(Grievance g) {
    return '''
🚨 *CITIZEN GRIEVANCE DOSSIER - JANSEVA*
Docket No: ${g.govtDocketNumber ?? g.id}
Department: ${g.govtDepartmentName ?? g.category.displayNameEn}
Location: ${g.address} (Ward: ${g.wardName})
Status: ${g.status.labelEn.toUpperCase()}
Reported Issue: *${g.title}*

"${g.description}"

GPS Coordinates: ${g.latitude.toStringAsFixed(4)}° N, ${g.longitude.toStringAsFixed(4)}° E
Track on Municipal Gateway: https://janseva.gov.in/track/${g.id}

Citizens Charter Statutory SLA: 48 Hours. Please inspect immediately!
''';
  }

  /// Shares full citizen complaint dossier to WhatsApp / Telegram / Colony groups
  static Future<void> shareGrievanceDossier(Grievance g) async {
    final text = buildWhatsAppMessage(g);
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Civic Complaint Docket: ${g.govtDocketNumber ?? g.id}',
      ),
    );
  }
}
