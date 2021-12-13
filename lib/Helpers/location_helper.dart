import 'dart:convert';
import 'package:http/http.dart' as http;

class Gkey {
  static const GOOGLE_API_KEY = 'AIzaSyCVfGZvev-B6xc517u0loV3p0dmE_-FV0g';
}

class LocationHelper {
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Gkey.GOOGLE_API_KEY}");
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
