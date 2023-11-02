import 'package:flutter/material.dart';

import '../account_settings/my_user_page.dart';
import '../map/map_screen.dart';
import '../talk/talk_room.dart';
import 'timeline_page.dart';

class BottomTabNavigator extends StatefulWidget {
  final int initialIndex; // initialIndexパラメータを追加
  final String? userId;

  const BottomTabNavigator(
      {super.key,
      required this.initialIndex,
      required this.userId}); // コンストラクタにパラメータを追加

  @override
  State<BottomTabNavigator> createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedTab(widget.initialIndex); // initialIndexで選択されたタブを設定
  }

  void _selectedTab(int index) {
    if (index == 3) {
      _screens[3] = const UserAccountPage();
      _selectedIndex = 3;
      return;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _screens = [
    TimelinePage(),
    const TalkRoomPage(),
    const MapPage(),
    const UserAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.indigo[900],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
          BottomNavigationBarItem(icon: Icon(Icons.room), label: 'map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
