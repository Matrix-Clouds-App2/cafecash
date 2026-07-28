
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

String? kCityName;

class HelperMethods {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // هل GPS شغال؟
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // الصلاحيات
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
  static Future<void> openGoogleMaps({
    required double lat,
    required double lng,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try{
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication, // 👈 يفتح الأبلكيشن مباشرة
      );
    }catch(e){
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
  static Future<String> getCityName(String languageCode) async {
    // إذا كان لدينا اسم المدينة من قبل، أرجعه مباشرة
    if (kCityName != null && kCityName!.isNotEmpty) {
      print('Using cached city name: $kCityName');
      return kCityName!;
    }

    try {
      // التحقق من تفعيل خدمات الموقع
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      print('isLocationEnabled: $isLocationEnabled');

      if (!isLocationEnabled) {
        print('Location services are disabled');
        kCityName = 'Baku'; // قيمة افتراضية
        return kCityName!;
      }

      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          kCityName = 'Baku'; // قيمة افتراضية
          return kCityName!;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        kCityName = 'Baku'; // قيمة افتراضية
        return kCityName!;
      }

      // الحصول على الموقع
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      
      // جلب اسم المدينة
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': position.latitude,
          'lon': position.longitude,
          'accept-language': languageCode,
        },
        options: Options(headers: {'User-Agent': 'WUF13-EventApp'}),
      );
      
      print('getCityName response received');
      final address = response.data['address'] as Map<String, dynamic>;

      final cityName = address['city'] ??
                       address['town'] ??
                       address['village'] ??
                       address['state'] ??
                       'Baku';

      kCityName = cityName;
      print('City name cached: $kCityName');
      return kCityName!;

    } catch (e) {
      print('getCityName error: $e');
      // استخدام القيمة المحفوظة أو قيمة افتراضية
      kCityName = kCityName ?? 'Baku';
      return kCityName!;
    }
  }
}

