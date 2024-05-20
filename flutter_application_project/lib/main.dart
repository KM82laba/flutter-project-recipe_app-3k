// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_project/screens/Welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import './constants.dart';
import './models/NavItem.dart';
import './screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        theme: ThemeData(
          // backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}