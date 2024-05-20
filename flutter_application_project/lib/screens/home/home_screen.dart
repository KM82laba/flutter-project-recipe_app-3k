import 'package:flutter/material.dart';
import 'package:flutter_application_project/screens/ReciepList/list_recipes_screen.dart';
import 'package:flutter_application_project/screens/Welcome/welcome_screen.dart';
import 'package:flutter_application_project/services/AuthService.dart';
import 'package:flutter_application_project/utils/utils.dart';
import '../../screens/home/components/body.dart';
import '../../size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      // bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          SolarIconsOutline.exit,
          size: 30,
          ),
        color: Colors.black,
        onPressed: () {
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
      centerTitle: true,
      title: Image.asset(
        "assets/images/logo_home_2.jpg",
        height: 100,
        width: 100,
        ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            SolarIconsOutline.magnifier,
          size: 30,
          ),
          onPressed: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ListReciepScreen();
                        },
                      ),
                );
          },
        ),
        SizedBox(
          width: SizeConfig.defaultSize * 0.5,
        )
      ],
    );
  }
}
