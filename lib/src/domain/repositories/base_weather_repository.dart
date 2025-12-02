import '../entities/weather_entity.dart';

abstract class BaseWeatherRepository {
  Future<List<WeatherEntity>> getForecast(double lat, double lng);
}