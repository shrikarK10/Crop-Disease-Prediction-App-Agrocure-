import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({Key? key, required this.selectedIndex, required this.onTap})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content of the page (BottomNavigationBar here)
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60), // Adjust the radius for top-left corner
            topRight: Radius.circular(60),
          ),
          child: Container(
            height: 100,
            width: double.infinity, // Use full width of screen
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart),
                  label: 'Stats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud),
                  label: 'Weather',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              backgroundColor: Colors.cyan[100],
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
        // Logout button positioned at top-left of the page (outside the navigation bar)

        ],

    );

  }
}
