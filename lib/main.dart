import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/data/datasources/weather_api_datasource.dart';
import 'src/data/repositories/weather_repository_impl.dart';
import 'src/domain/usecases/get_forecast_usecase.dart';
import 'src/presentation/view/home_page.dart';
import 'src/presentation/viewmodel/weather_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyección de Dependencias
    final datasource = WeatherApiDatasource();
    final repository = WeatherRepositoryImpl(datasource);
    final usecase = GetForecastUseCase(repository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel(usecase)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Api Mateo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}