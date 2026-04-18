import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/plant/model/weather_model.dart';

class WeatherService {
  final String _apiKey = dotenv.get('OPENWEATHER_API_KEY');
  final baseUrl = dotenv.get('OPENWEATHER_BASE_URL');
  final path = dotenv.get('OPENWEATHER_PATH');

  Future<WeatherData?> fetchWeather(double lat, double lon) async {
    try {
      final uri = Uri.https(
        baseUrl,
        path,
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}