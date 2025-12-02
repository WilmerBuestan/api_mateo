import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/base_weather_repository.dart';
import '../datasources/weather_api_datasource.dart';

class WeatherRepositoryImpl implements BaseWeatherRepository {
  final WeatherApiDatasource datasource;

  WeatherRepositoryImpl(this.datasource);

  @override
  Future<List<WeatherEntity>> getForecast(double lat, double lng) async {
    return await datasource.fetchForecast(lat, lng);
  }
}