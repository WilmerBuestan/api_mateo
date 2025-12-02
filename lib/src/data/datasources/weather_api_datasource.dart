import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiDatasource {
  final String baseUrl = "https://api.open-meteo.com/v1/forecast";

  Future<List<WeatherModel>> fetchForecast(double lat, double lng) async {
    // Pedimos temperatura max y min diaria
    final url = Uri.parse(
        "$baseUrl?latitude=$lat&longitude=$lng&daily=temperature_2m_max,temperature_2m_min&timezone=auto");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Error al cargar datos del clima');
    }
  }
}