import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'common_widgets/custom_nav_bar.dart';
import 'common_widgets/logout_button.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int _selectedIndex = 2;

  String temperature = '';
  String sunrise = '';
  String sunset = '';
  String description = '';
  String location = '';
  String weatherIcon = '';
  String humidity = '';
  String precipitation = '';
  bool isLoading = true;

  final String apiKey = 'ad28d8867d4ecc2a12600fa8bf78e8f1';
  final String baseUrl = 'http://api.weatherstack.com/current';

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      fetchWeather(position.latitude, position.longitude);
    } else {
      setState(() {
        description = 'Location permission denied.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeather(double lat, double lon) async {
    final url = Uri.parse('$baseUrl?access_key=$apiKey&query=$lat,$lon&units=m');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            temperature = data['current']['temperature'].toString();
            description = data['current']['weather_descriptions'][0];
            location = data['location']['name'];
            weatherIcon = data['current']['weather_icons'][0];
            sunrise=data['current']['astro']['sunrise'];
            sunset=data['current']['astro']['sunset'];
            humidity = data['current']['humidity'].toString();
            precipitation = data['current']['precip'].toString();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            description = 'Failed to load weather data';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          description = 'Error: $e';
          isLoading = false;
        });
      }
    }
  }

  void _onNavBarTap(int index) {
    if (index != _selectedIndex) {
      String route;
      switch (index) {
        case 0:
          route = '/home';
          break;
        case 1:
          route = '/chart';
          break;
        case 3:
          route = '/account';
          break;
        default:
          route = '/weather';
      }
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('E. dd. MMMM. HH:mm').format(now);
    String weatherImage = '';

    if (description.toLowerCase().contains('sunny')) {
      weatherImage = 'assets/weather/sunny.png';
    } else if (description.toLowerCase().contains('cloudy')) {
      weatherImage = 'assets/weather/cloudy.png';
    } else if (description.toLowerCase().contains('rain')) {
      weatherImage = 'assets/weather/rainy.png';
    } else {
      weatherImage = 'assets/weather/default.png'; // Default image
    }
    return Scaffold(
      backgroundColor: const Color(0xFFd9efff),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                    width: 390,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          weatherImage, // Display the custom image based on description
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          '$temperature°',
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          location,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.water_drop, color: Colors.black),
                                Text(
                                  '$humidity%',
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const Text('Humidity',
                                    style: TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.grain, color: Colors.black),
                                Text(
                                  '$precipitation %',
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const Text('Precipitation',
                                    style: TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.sunny, color: Colors.black),
                                Text(
                                  '$sunrise',
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const Text('Sunrise',
                                    style: TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.sunny_snowing, color: Colors.black),
                                Text(
                                  '$sunset',
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const Text('Sunset',
                                    style: TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              CustomNavBar(
                selectedIndex: _selectedIndex,
                onTap: _onNavBarTap,
              ),
            ],
          ),
          const LogoutButton(),
        ],
      ),
    );
  }
}
