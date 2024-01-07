import 'dart:convert';
import 'dart:developer';

import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const _apiKey = 'ede67942d656d0b35e17ae830467c173';
const openWeatherMapURL='https://api.openweathermap.org/data/2.5/weather';
class WeatherModel {

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    if (location.getLatitude() == null || location.getLongitude() == null) {
      return 'Location services are denied';
    }

    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$openWeatherMapURL?lat=${location.getLatitude()}&lon=${location.getLongitude()}&appid=$_apiKey&units=metric');

    String responseBody = await networkHelper.getRequest();

    var dataToPass;
    try {
      if (responseBody != null) {
        dataToPass = jsonDecode(responseBody);
      } else {
        log('bad request: ', error: 'Cannot get OK response');
        dataToPass = 'API error, Try again Later';
      }
    } catch (e) {
      log('error getting response from server: ', error: e);
      dataToPass = 'Some problem occured, Try Again';
    }
    return dataToPass;
  }

  Future<dynamic> getCityWeather(String cityName)async{
    NetworkHelper networkHelper = NetworkHelper(
        url:
        '$openWeatherMapURL?q=$cityName&appid=$_apiKey&units=metric');

    String responseBody = await networkHelper.getRequest();

    var dataToPass;
    try {
      if (responseBody != null) {
        dataToPass = jsonDecode(responseBody);
      } else {
        log('bad request: ', error: 'Cannot get OK response');
        dataToPass = 'API error, Try again Later';
      }
    } catch (e) {
      log('error getting response from server: ', error: e);
      dataToPass = 'Some problem occured, Try Again';
    }
    return dataToPass;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
