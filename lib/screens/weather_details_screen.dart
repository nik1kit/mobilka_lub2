import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherModel model;

  const WeatherDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.city)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  model.city,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Center(child: Text(model.temp, style: TextStyle(fontSize: 24))),
              SizedBox(height: 12),
              Text(
                'Wind: ${model.windSpeed.toStringAsFixed(1)} m/s, ${model.windDirection.toStringAsFixed(0)}°',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Weather code: ${model.weatherCode}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Temperature in Fahrenheit: ${(model.temperature * 9 / 5 + 32).toStringAsFixed(1)} °F',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              // Пример дополнительной информации
              Text(
                'Feels like: ${(model.temperature + 2).toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              // Можно добавить ещё любые данные, которые есть в модели
            ],
          ),
        ),
      ),
    );
  }
}
