import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_application/models/weather_model.dart';
import 'package:weather_application/services/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(dotenv.env['OPEN_WEATHER_API_KEY'] ?? "");
  Weather? _weather;
  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }
  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'dust':
        return 'assets/drizzle.json';
      default:
        return 'assets/sunny.json';
    }
  }
  // init states
  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_weather?.cityName ?? "loading city.."),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          Text('${_weather?.temprature.round()}C'),
          Text(_weather?.mainCondition ?? '')
        ],
      ),
    ));
  }
}
