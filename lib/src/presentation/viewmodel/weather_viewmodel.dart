import 'package:flutter/material.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherViewModel extends ChangeNotifier {
  final GetForecastUseCase getForecastUseCase;

  WeatherViewModel(this.getForecastUseCase);

  // --- VARIABLES DE ESTADO ---
  List<WeatherEntity> _fullList = [];      // Lista maestra (toda la data descargada)
  List<WeatherEntity> _displayedList = []; // Lista visible en pantalla
  bool _isLoading = false;

  // Filtros: 'all', 'hot', 'cold'
  String _currentFilter = 'all';

  // Paginación
  int _currentPage = 0;
  final int _pageSize = 5; // Mostramos de 5 en 5 días

  // --- GETTERS (Lo que ve la UI) ---
  List<WeatherEntity> get weatherList => _displayedList;
  bool get isLoading => _isLoading;
  String get currentFilter => _currentFilter;

  // --- MÉTODOS ---

  // 1. Cargar datos iniciales
  Future<void> loadWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Coordenadas de Quito (o lo que use su API)
      _fullList = await getForecastUseCase.execute(-0.2299, -78.5249);

      // Al cargar, aplicamos filtro 'all' por defecto y paginamos
      applyFilter('all');

    } catch (e) {
      print("Error cargando clima: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Aplicar Filtros (Lógica Avanzada)
  void applyFilter(String type) {
    _currentFilter = type;
    _currentPage = 0; // Resetear página al cambiar filtro

    if (type == 'all') {
      // Si es 'todos', reiniciamos la paginación normal
      _updatePagination();
    } else if (type == 'hot') {
      // Filtrar días > 15°C (Mostramos todos los que coincidan de una)
      _displayedList = _fullList.where((e) => e.maxTemp > 15.0).toList();
    } else if (type == 'cold') {
      // Filtrar días < 10°C
      _displayedList = _fullList.where((e) => e.minTemp < 10.0).toList();
    }

    notifyListeners();
  }

  // 3. Paginación (Cargar más días)
  void loadMore() {
    // Solo permitimos cargar más si estamos en modo 'todos' y hay datos
    if (_currentFilter == 'all' && _displayedList.length < _fullList.length) {
      _currentPage++;
      _updatePagination();
      notifyListeners();
    }
  }

  // Auxiliar para calcular la lista paginada
  void _updatePagination() {
    int endIndex = (_currentPage + 1) * _pageSize;
    if (endIndex > _fullList.length) endIndex = _fullList.length;
    _displayedList = _fullList.sublist(0, endIndex);
  }
}