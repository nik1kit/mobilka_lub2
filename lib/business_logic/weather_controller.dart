
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

enum WeatherState { idle, loading, error, success }

class WeatherController extends ChangeNotifier {
  WeatherModel? model;
  WeatherState state = WeatherState.idle;

  Future<void> getWeather(String city, double lat, double lon) async {
    state = WeatherState.loading;
    model = null;
    notifyListeners();

    final cleanCity = city.trim();
    final cacheKey = '$cleanCity-$lat-$lon';

    try {
      final sp = await SharedPreferences.getInstance();

      // Загружаем из кэша
      final cached = sp.getString(cacheKey);
      if (cached != null) {
        final jsonData = json.decode(cached);
        model = WeatherModel.fromJson(jsonData, cleanCity);
        state = WeatherState.success;
        notifyListeners();
        return;
      }

      // Получаем с API
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true',
        ),
      );

      if (response.statusCode != 200)
        throw Exception('Error ${response.statusCode}');

      final jsonData = json.decode(response.body);
      model = WeatherModel.fromJson(jsonData, cleanCity);
      state = WeatherState.success;
      notifyListeners();

      // Сохраняем кэш
      await sp.setString(cacheKey, json.encode(jsonData));

      // Сохраняем историю
      await _saveHistory(model!, cleanCity);
    } catch (e) {
      state = WeatherState.error;
      notifyListeners();
    }
  }

  Future<void> _saveHistory(WeatherModel model, String city) async {
    final sp = await SharedPreferences.getInstance();
    final cacheKey = 'history-$city';
    final oldHistory = sp.getStringList(cacheKey) ?? [];

    final newEntry = json.encode(model.toJson());
    oldHistory.add(newEntry);

    await sp.setStringList(cacheKey, oldHistory);
  }

  Future<List<WeatherModel>> getHistory(String city) async {
    final sp = await SharedPreferences.getInstance();
    final cleanCity = city.trim();
    final oldHistory = sp.getStringList('history-$cleanCity') ?? [];
    return oldHistory
        .map((e) => WeatherModel.fromJson(json.decode(e), cleanCity))
        .toList();
  }
}
