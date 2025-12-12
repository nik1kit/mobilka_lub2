import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../screens/weather_details_screen.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel model;
  const WeatherCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Переход на экран с деталями
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WeatherDetailsScreen(model: model)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model.city, style: TextStyle(fontSize: 22)),
            SizedBox(height: 8),
            Text(model.temp, style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text(model.description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
