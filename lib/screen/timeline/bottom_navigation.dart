import 'package:flutter/material.dart';

import '../screen/account_settings/my_user_page.dart';
import '../screen/map/map_screen.dart';
import '../screen/talk/talk_room.dart';
import '../screen/timeline/timeline_page.dart';

class BottomTabNavigator extends StatefulWidget {
  final int initialIndex; // initialIndexパラメータを追加
  final String? userId;

  BottomTabNavigator(
      {required this.initialIndex, required this.userId}); // コンストラクタにパラメータを追加

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
      _screens[3] = UserAccountPage();
      _selectedIndex = 3;
      return;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List _screens = [
    TimelinePage(),
    TalkRoomPage(),
    HomePage(),
    UserAccountPage(),
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
