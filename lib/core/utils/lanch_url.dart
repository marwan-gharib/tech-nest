import 'package:tech_nest/core/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class LanchUrl {
  static Future<void> launch(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (e) {
      AppLogger.log(e.toString());
    }
  }
}
