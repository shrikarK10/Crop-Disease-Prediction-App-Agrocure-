// main.dart
import 'package:flutter/material.dart';
import 'package:untitled/pages/account_page.dart';
import 'package:untitled/pages/chart_page.dart';
import 'package:untitled/pages/weather_page.dart';
import 'package:untitled/pages/login_page.dart';
import 'package:untitled/pages/registration_page.dart';
import 'package:untitled/pages/home_page.dart';
import 'package:untitled/pages/common_widgets/loading_page.dart'; // Retain the LoadingPage import

// Global state for prediction
class PredictionState {
  static String currentPrediction = "No prediction yet";
  static bool hasPrediction = false;

  static void updatePrediction(String prediction) {
    currentPrediction = prediction;
    hasPrediction = true;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(), // Set the LoginPage as the initial screen
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/chart': (context) => ChartPage(),
        '/weather': (context) => WeatherPage(),
        '/account': (context) => AccountPage(),
        '/loading': (context) => LoadingScreen(), // Add LoadingPage to the routes
      },
    );
  }
}
