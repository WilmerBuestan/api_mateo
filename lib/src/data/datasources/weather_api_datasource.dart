


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiDatasource {
  // Ponga aquí su IP local cuando el Docker esté listo.
  // Puerto 8080 es el default de Open-Meteo docker.
  final String baseUrl = "http://10.40.29.144:8080/v1/forecast";

  // INTERRUPTOR DE SIMULACRO
  // true = usa datos falsos (para avanzar mientras descarga Docker)
  // false = intenta conectar al servidor real
  final bool useMock = true;

  Future<List<WeatherModel>> fetchForecast(double lat, double lng) async {
    if (useMock) {
      // Retraso artificial para simular internet
      await Future.delayed(const Duration(seconds: 1));
      return _getMockData();
    }

    try {
      final url = Uri.parse(
          "$baseUrl?latitude=$lat&longitude=$lng&daily=temperature_2m_max,temperature_2m_min&timezone=auto");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Datos falsos para probar Paginación y Filtros AHORA
  List<WeatherModel> _getMockData() {
    return List.generate(15, (index) {
      // Generamos 15 días con temperaturas aleatorias
      return WeatherModel(
        date: "2025-11-${(20 + index).toString()}",
        maxTemp: 10.0 + (index * 1.5) % 15, // Variar temp
        minTemp: 5.0 + (index * 1.0) % 10,
      );
    });
  }
}