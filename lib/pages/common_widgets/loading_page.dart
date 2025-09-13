import 'package:flutter/material.dart';
import 'package:untitled/pages/login_page.dart'; // Ensure LoginPage is imported

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin(); // Navigate to the login screen after a delay
  }

  void _navigateToLogin() async {
    try {
      await Future.delayed(Duration(seconds: 5)); // Simulate loading time
      if (mounted) {
        Navigator.pushReplacement(context, _noAnimationRoute(LoginPage())); // Navigate to LoginPage
      }
    } catch (e) {
      debugPrint("Error during navigation: $e");
    }
  }

  Route _noAnimationRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero, // No transition
      reverseTransitionDuration: Duration.zero, // No reverse transition
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/icon.png', // Asset image displayed during the splash
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'AgroCure',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator(), // Add a loading indicator
          ],
        ),
      ),
    );
  }
}
