import '../entities/weather_entity.dart';
import '../repositories/base_weather_repository.dart';

class GetForecastUseCase {
  final BaseWeatherRepository repository;

  GetForecastUseCase(this.repository);

  Future<List<WeatherEntity>> execute(double lat, double lng) {
    return repository.getForecast(lat, lng);
  }
}