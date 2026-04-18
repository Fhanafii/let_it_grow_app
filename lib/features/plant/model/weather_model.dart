class WeatherData {
  final double temp;
  final String cityName;

  WeatherData({required this.temp, required this.cityName});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: (json['main']['temp'] as num).toDouble(),
      cityName: json['name'],
    );
  }
}
