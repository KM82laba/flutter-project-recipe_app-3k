// ignore_for_file: avoid_print, prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_application_project/screens/Welcome/welcome_screen.dart';
import 'package:flutter_application_project/screens/profile/list_fav_recips_screen.dart';
import 'package:flutter_application_project/screens/profile/profile_reciep_screen.dart';
import 'package:flutter_application_project/services/AuthService.dart';
import 'package:flutter_application_project/utils/utils.dart';
import '../../../size_config.dart';
import 'info.dart';
import 'profile_menu_item.dart';

class Body extends StatelessWidget {
  final Map<String, String?> userData;

  const Body({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            image: "assets/images/profile_pic.png",
            name: "${userData['firstName']!} ${userData['lastName']!}",
            email: userData['username']!,
          ),
          SizedBox(height: SizeConfig.defaultSize * 2), //20
          ProfileMenuItem(
            icon: SolarIconsOutline.bookmark,
            title: "Saved Recipes",
            press: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ListFavReciepScreen();
                  }
                )
              );
              },
          ),
          ProfileMenuItem(
            icon: SolarIconsOutline.chefHat,
            title: "My Recipes",
            press: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileListRecieps();
                  }
                )
              );
            },
          ),
          ProfileMenuItem(
            icon: SolarIconsOutline.exit,
            title: "Exit",
            press: () {
                AuthService().logout();
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const WelcomeScreen();
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
