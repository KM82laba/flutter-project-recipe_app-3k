
import 'package:flutter_application_project/screens/ReciepCreateScreen/create_reciep_screen.dart';
import 'package:flutter_application_project/screens/ReciepList/list_recipes_screen.dart';
import 'package:flutter_application_project/screens/home/home_screen.dart';
import 'package:flutter_application_project/screens/profile/prrofile_screen.dart';
import 'package:flutter_application_project/utils/utils.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _BottonNavBarState();
}

class _BottonNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const ListReciepScreen(),
    const CreateReciepScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(206, 206, 206, 0.29), offset: Offset(0, -4),
              blurRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: const Color.fromRGBO(85, 127, 116, 0.741),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.home,
                ),
                activeIcon: Icon(
                  SolarIconsBold.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.compass,
                ),
                activeIcon: Icon(
                  SolarIconsBold.compass,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.documentAdd,
                ),
                activeIcon: Icon(
                  SolarIconsBold.documentAdd,
                ),
                label: 'Add recipe',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.user,
                ),
                activeIcon: Icon(
                  SolarIconsBold.user,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
