import 'package:flutter/material.dart';
import 'package:trendtrack/screens/home_screen.dart';
import 'package:trendtrack/screens/profile_page.dart';
import 'package:trendtrack/screens/search_screen.dart';

class BottNavBar extends StatefulWidget {
  const BottNavBar({Key? key}) : super(key: key);

  @override
  State<BottNavBar> createState() => _BottNavBarState();
}

class _BottNavBarState extends State<BottNavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    searchscreen(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // If Profile is tapped, navigate to the profile screen
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        width: 284,
        height: 66,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 16, 15, 15).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
