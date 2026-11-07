import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> openWhatsApp(String phone, String message) async {
    final Uri url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }
}
