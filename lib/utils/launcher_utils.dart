import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  LauncherUtils._();

  static Future<void> openUrl(String url) async {
     if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
     } else {
        throw 'Could not open the url';
     }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
     if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl));
     } else {
        throw 'Could not open the map.';
     }
  }
}