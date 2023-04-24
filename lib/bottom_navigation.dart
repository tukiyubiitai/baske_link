import 'package:basketball_app/screen/signin/user_info_screen.dart';
import 'package:basketball_app/screen/timeline/timeline_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screen/map_screen.dart';
import 'screen/talk_page.dart';

class MyStatefulWidget extends StatefulWidget {
  final User user;

  MyStatefulWidget({required this.user});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late List _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TimelinePage(
        user: widget.user,
      ),
      TalkPage(),
      HomePage(),
      UserInfoScreen(user: widget.user),
    ];
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
            BottomNavigationBarItem(icon: Icon(Icons.room), label: 'map'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
