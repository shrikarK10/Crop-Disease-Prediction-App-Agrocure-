import 'package:flutter/material.dart';


class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  void navigateToLoading(BuildContext context) {
    // Navigate to loading screen when logout button is tapped
    Navigator.pushReplacementNamed(context, '/loading');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AgroCure text with emoji at the top-left corner
        Positioned(
          top: 35,
          left: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'AgroCure',
                style: TextStyle(
                  fontSize: 24, // Adjust font size for visibility
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 22,
          left: 113,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 0), // Adjust spacing between text and emoji
              Image.asset(
                'assets/nameicon.png',
                width: 44, // Adjust size based on your preference
                height: 44,
              ),
            ],
          ),
        ),
        // Logout button at the top-right corner
        Positioned(
          top:33, // Position from the top of the screen
          right: 16, // Position from the left edge
          child: GestureDetector(
            onTap: () => navigateToLoading(context),
            child: Container(
              padding: EdgeInsets.all(8), // Padding around the icon
              decoration: BoxDecoration(
                color: Colors.cyan[100], // Background color for the logout button
                shape: BoxShape.circle, // Circle shape for the button
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.black, // White color for the icon
                size: 24, // Size of the icon
              ),
            ),
          ),
        ),
      ],
    );
  }
}
