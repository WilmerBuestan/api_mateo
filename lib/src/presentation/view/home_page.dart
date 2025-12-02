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
    // Cargar datos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherViewModel>(context, listen: false).loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Quito - Clean Arch'),
        backgroundColor: Colors.indigo,
        actions: [
          // Control de Filtro
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'hot') viewModel.filterHotDays(true);
              if (value == 'all') viewModel.filterHotDays(false);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Ver Todo')),
              const PopupMenuItem(value: 'hot', child: Text('Solo días > 15°C')),
            ],
          )
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.weatherList.length,
              itemBuilder: (context, index) {
                final item = viewModel.weatherList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
                      title: Text(
                        item.date,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Max: ${item.maxTemp}°C  Min: ${item.minTemp}°C"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón de "Cargar más" (Paginación)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => viewModel.loadMore(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text("Cargar siguientes días (Paginar)"),
            ),
          )
        ],
      ),
    );
  }
}