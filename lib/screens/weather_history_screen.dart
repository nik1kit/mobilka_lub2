import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business_logic/weather_controller.dart';
import '../models/weather_model.dart';

class WeatherHistoryScreen extends StatefulWidget {
  final String city;

  const WeatherHistoryScreen({super.key, required this.city});

  @override
  _WeatherHistoryScreenState createState() => _WeatherHistoryScreenState();
}

class _WeatherHistoryScreenState extends State<WeatherHistoryScreen> {
  late Future<List<WeatherModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<WeatherController>(context, listen: false);
    // Используем trim() для очистки пробелов
    historyFuture = controller.getHistory(widget.city.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История погоды: ${widget.city.trim()}')),
      body: FutureBuilder<List<WeatherModel>>(
        future: historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки истории'));
          }

          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return Center(child: Text('История пока пустая'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.city,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Температура: ${item.temp}'),
                    Text(
                      'Ветер: ${item.windSpeed.toStringAsFixed(1)} м/с, ${item.windDirection.toStringAsFixed(0)}°',
                    ),
                    Text('Код погоды: ${item.weatherCode}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
