import 'package:flutter/material.dart';

import '../views/account/my_user_page.dart';
import '../views/chat/talk_room.dart';
import '../views/home/timeline_page.dart';
import '../views/map/map_screen.dart';

class BottomTabNavigator extends StatefulWidget {
  final int initialIndex; // initialIndexパラメータを追加
  final String? userId;

  const BottomTabNavigator(
      {super.key, required this.initialIndex, this.userId}); // コンストラクタにパラメータを追加

  @override
  State<BottomTabNavigator> createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List _screens = [
    TimelinePage(),
    const TalkRoomList(),
    MapPage(),
    const MyUserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
