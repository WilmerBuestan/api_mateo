import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.date,
    required super.maxTemp,
    required super.minTemp,
  });

  // Open-Meteo devuelve arrays separados (time, temp_max, temp_min)
  // Este método convierte esos arrays en una lista de objetos
  static List<WeatherModel> fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    final List<dynamic> dates = daily['time'];
    final List<dynamic> maxTemps = daily['temperature_2m_max'];
    final List<dynamic> minTemps = daily['temperature_2m_min'];

    List<WeatherModel> list = [];
    for (int i = 0; i < dates.length; i++) {
      list.add(WeatherModel(
        date: dates[i].toString(),
        maxTemp: (maxTemps[i] as num).toDouble(),
        minTemp: (minTemps[i] as num).toDouble(),
      ));
    }
    return list;
  }
}