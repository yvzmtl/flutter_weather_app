import 'dart:convert';

import 'package:flutter_weather_app_new/const/const.dart';
import 'package:flutter_weather_app_new/models/forecast_result.dart';
import 'package:flutter_weather_app_new/models/weather_result.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class OpenWeatherMapClient {
  Future<WeatherResult> getWeather(LocationData locationData) async {
    if (locationData.latitude != null && locationData.longitude != null) {
      final res = await http.get(Uri.parse(
          '$apiEndpoint/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&units=metric&appid=$apiKey'));
      if (res.statusCode == 200) {
        return WeatherResult.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Zayıf Bağlantı');
      }
    } else {
      throw Exception("Hatalı Konum");
    }
  }

  Future<ForecastResult> getForecast(LocationData locationData) async {
    if (locationData.latitude != null && locationData.longitude != null) {
      final res = await http.get(Uri.parse(
          '$apiEndpoint/forecast?lat=${locationData.latitude}&lon=${locationData.longitude}&units=metric&appid=$apiKey'));
      if (res.statusCode == 200) {
        return ForecastResult.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Zayıf Bağlantı');
      }
    } else {
      throw Exception("Hatalı Konum");
    }
  }
}
