import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_neal/Screens/home_screen.dart';
import 'package:project_neal/Screens/profile_screen.dart';
import 'package:project_neal/Screens/smart_screen.dart';
import 'package:project_neal/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    SmartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGOffWhite,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GNav(
              onTabChange: _navigateBottomBar,
              backgroundColor: Colors.white,
              tabActiveBorder: Border.all(color: kButtonDarkBlue, width: 1),
              activeColor: kButtonDarkBlue,

              // tabBackgroundColor: Colors.black12,
              padding: const EdgeInsets.all(15),
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.wb_sunny_outlined,
                  text: 'Smart',
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: 'Profile',
                ),
              ]),
        ),
      ),
    );
  }
}


// BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _navigateBottomBar,
//           type: BottomNavigationBarType.fixed,
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           ]),