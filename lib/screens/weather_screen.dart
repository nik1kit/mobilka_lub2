import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business_logic/weather_controller.dart';
import '../widgets/weather_card.dart';
import 'weather_history_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cityController = TextEditingController();
    final latController = TextEditingController();
    final lonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              final city = cityController.text.trim();
              if (city.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WeatherHistoryScreen(city: city),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: latController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lonController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final city = cityController.text.trim();
                final lat = double.tryParse(latController.text) ?? 0;
                final lon = double.tryParse(lonController.text) ?? 0;
                if (city.isNotEmpty) {
                  Provider.of<WeatherController>(
                    context,
                    listen: false,
                  ).getWeather(city, lat, lon);
                }
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Consumer<WeatherController>(
                builder: (context, controller, _) {
                  switch (controller.state) {
                    case WeatherState.idle:
                      return Center(child: Text('Enter city to fetch weather'));
                    case WeatherState.loading:
                      return Center(child: CircularProgressIndicator());
                    case WeatherState.error:
                      return Center(child: Text('Error fetching weather'));
                    case WeatherState.success:
                      return WeatherCard(model: controller.model!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
