import 'package:url_launcher/url_launcher.dart';

class HelperMethods {
  static Future<void> openGoogleMaps({
    required double lat,
    required double lng,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not open Google Maps';
    }
  }

  static Future<void> openLink(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
