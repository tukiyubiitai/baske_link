import 'package:basketball_app/providers/map_provider.dart';
import 'package:basketball_app/providers/tag_provider.dart';
import 'package:basketball_app/screen/authentication/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/area_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MapProvider>(
          create: (context) => MapProvider(),
        ),
        ChangeNotifierProvider<TagProvider>(
          create: (context) => TagProvider(),
        ),
        ChangeNotifierProvider<AreaProvider>(
          create: (context) => AreaProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginAndSignupPage(),
    );
  }
}
