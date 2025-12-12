
class WeatherModel {
  final String city;
  final double temperature;
  final double windSpeed;
  final double windDirection;
  final int weatherCode;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, [String? city]) {
    final current = json['current_weather'] ?? json;
    return WeatherModel(
      city: city ?? json['city'] ?? 'Unknown',
      temperature: (current['temperature'] as num).toDouble(),
      windSpeed: (current['windspeed'] as num).toDouble(),
      windDirection: (current['winddirection'] as num).toDouble(),
      weatherCode: current['weathercode'] as int,
    );
  }

  // Геттеры для отображения в виджетах
  String get temp => '${temperature.toStringAsFixed(1)} °C';
  String get description =>
      'Wind: ${windSpeed.toStringAsFixed(1)} m/s, ${windDirection.toStringAsFixed(0)}°';

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'windspeed': windSpeed,
    'winddirection': windDirection,
    'weathercode': weatherCode,
  };
}
