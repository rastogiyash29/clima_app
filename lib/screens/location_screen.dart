import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/loading_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.weatherData});

  final weatherData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late String temprature;
  late String condition;
  late String cityName;
  late String weatherIcon;
  late String suggestion;
  late WeatherModel weatherModel;
  @override
  void initState() {
    super.initState();
    weatherModel=WeatherModel();
    setState(() {
      updateUI(widget.weatherData);
    });
  }

  void updateUI(dynamic weatherData) {
    if (widget.weatherData.runtimeType == String) {
      condition = weatherData;
      cityName = '?';
      temprature = '~';
      weatherIcon = '?';
      suggestion = '';
    } else {
      //error case
      try {
        temprature = weatherData['main']['temp'].toInt().toString();
        condition = weatherData['weather'][0]['main'].toString();
        cityName = weatherData['name'];
        weatherIcon =
            weatherModel.getWeatherIcon(weatherData['weather'][0]['id']);
        suggestion =
            weatherModel.getMessage(weatherData['main']['temp'].toInt());
      } catch (e) {
        condition = 'Server error!!';
        cityName = '?';
        temprature = '~';
        weatherIcon = '?';
        suggestion = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: ()async{
                      var weatherData=await weatherModel.getLocationWeather();
                      setState(() {
                        updateUI(weatherData);
                      });
                      },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      var cityName=await Navigator.push(context, MaterialPageRoute(builder: (context)=>CityScreen()));
                      if(cityName!=null){
                        var weatherData=await weatherModel.getCityWeather(cityName);
                        setState(() {
                          updateUI(weatherData);
                        });
                      }
                      },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${temprature}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "${suggestion}, ${condition} in ${cityName}!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
