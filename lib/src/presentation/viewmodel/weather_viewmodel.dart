import 'package:flutter/material.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherViewModel extends ChangeNotifier {
  final GetForecastUseCase getForecastUseCase;

  WeatherViewModel(this.getForecastUseCase);

  List<WeatherEntity> _fullList = []; // Lista completa descargada
  List<WeatherEntity> _displayedList = []; // Lista que se ve (paginada/filtrada)
  bool _isLoading = false;

  // Paginación
  int _currentPage = 0;
  final int _pageSize = 3; // Mostraremos de 3 en 3 días

  List<WeatherEntity> get weatherList => _displayedList;
  bool get isLoading => _isLoading;

  Future<void> loadWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Coordenadas de Quito, Ecuador
      _fullList = await getForecastUseCase.execute(-0.2299, -78.5249);
      _currentPage = 0;
      _updatePagination(); // Cargar primera "página"
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lógica de Paginación (Cargar más)
  void loadMore() {
    if (_displayedList.length < _fullList.length) {
      _currentPage++;
      _updatePagination();
      notifyListeners();
    }
  }

  void _updatePagination() {
    int endIndex = (_currentPage + 1) * _pageSize;
    if (endIndex > _fullList.length) endIndex = _fullList.length;
    _displayedList = _fullList.sublist(0, endIndex);
  }

  // Lógica de Filtro: Mostrar solo días calurosos (> 15 grados max)
  void filterHotDays(bool active) {
    if (active) {
      _displayedList = _fullList.where((element) => element.maxTemp > 15.0).toList();
    } else {
      // Resetear a paginación normal
      _currentPage = 0;
      _updatePagination();
    }
    notifyListeners();
  }
}