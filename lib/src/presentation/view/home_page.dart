import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carga los datos apenas se dibuja la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherViewModel>(context, listen: false).loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // USO DE SLIVERS (Requerimiento de Diseño Avanzado)
      body: CustomScrollView(
        slivers: [
          // 1. Barra Superior Elástica
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Meteo Militar'),
              background: Image.network(
                'https://images.unsplash.com/photo-1516912481808-3406841bd33c?q=80&w=1000&auto=format&fit=crop',
                fit: BoxFit.cover,
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
                errorBuilder: (c, o, s) => Container(color: Colors.indigo), // Fallback si no hay internet
              ),
            ),
          ),

          // 2. Sección de Filtros (Chips)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filtros Tácticos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      // Chip TODOS
                      FilterChip(
                        label: const Text('Todos'),
                        selected: viewModel.currentFilter == 'all',
                        onSelected: (_) => viewModel.applyFilter('all'),
                      ),
                      // Chip CALOR
                      FilterChip(
                        label: const Text('Calor (>15°C)'),
                        selected: viewModel.currentFilter == 'hot',
                        checkmarkColor: Colors.white,
                        selectedColor: Colors.orangeAccent,
                        onSelected: (_) => viewModel.applyFilter('hot'),
                      ),
                      // Chip FRÍO
                      FilterChip(
                        label: const Text('Frío (<10°C)'),
                        selected: viewModel.currentFilter == 'cold',
                        checkmarkColor: Colors.white,
                        selectedColor: Colors.lightBlueAccent,
                        labelStyle: TextStyle(
                            color: viewModel.currentFilter == 'cold' ? Colors.white : Colors.black
                        ),
                        onSelected: (_) => viewModel.applyFilter('cold'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Lista de Datos (o Loading)
          viewModel.isLoading
              ? const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()))
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = viewModel.weatherList[index];
                return _buildWeatherCard(item);
              },
              childCount: viewModel.weatherList.length,
            ),
          ),

          // 4. Botón de Paginación (Solo visible en filtro 'Todos')
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: (viewModel.currentFilter == 'all' && viewModel.weatherList.isNotEmpty)
                  ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.download),
                label: const Text("Cargar Siguiente Lote"),
                onPressed: () => viewModel.loadMore(),
              )
                  : const SizedBox.shrink(), // Ocultar si hay filtros activos
            ),
          ),

          // Espacio extra al final
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  // WIDGET AUXILIAR: Tarjeta de Clima
  Widget _buildWeatherCard(item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getColor(item.maxTemp).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIcon(item.maxTemp),
            color: _getColor(item.maxTemp),
          ),
        ),
        title: Text(
          "Fecha: ${item.date}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.arrow_upward, size: 16, color: Colors.red[300]),
              Text("Max: ${item.maxTemp}°C   ", style: const TextStyle(fontWeight: FontWeight.w500)),
              Icon(Icons.arrow_downward, size: 16, color: Colors.blue[300]),
              Text("Min: ${item.minTemp}°C", style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // Lógica visual simple para iconos y colores
  Color _getColor(double temp) {
    if (temp > 15) return Colors.orange;
    if (temp < 10) return Colors.blue;
    return Colors.green;
  }

  IconData _getIcon(double temp) {
    if (temp > 15) return Icons.wb_sunny;
    if (temp < 10) return Icons.ac_unit;
    return Icons.cloud;
  }
}