import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';

class LauncherHelper {
  /// Launches the phone dialer with the provided [number]
  static Future<void> makePhoneCall(BuildContext context, String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (!context.mounted) return;
        _handleError(context, number);
      }
    } catch (e) {
      if (!context.mounted) return;
      _handleError(context, number);
    }
  }

  static void _handleError(BuildContext context, String number) {
    if (!context.mounted) return;
    SnackbarHelper.showError(
      context,
      'Could not launch dialer for $number',
      showTop: true,
    );
  }
}
