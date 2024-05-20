// ignore_for_file: use_key_in_widget_constructors, avoid_print, camel_case_types, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_application_project/screens/profile/profile_edit_screen.dart';
import 'package:flutter_application_project/services/AuthService.dart';
import '../../constants.dart';
import '../../screens/profile/components/body.dart';
import '../../size_config.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getUserData(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color.fromARGB(255, 94, 94, 94),);
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final Map<String, String?> userData = snapshot.data ?? {};
        print(userData);
        return ProfileScreen_Container(userData: userData);
      },
    );
  }
}

class ProfileScreen_Container extends StatelessWidget {
  final Map<String, String?> userData;

  const ProfileScreen_Container({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(userData: userData),
      // bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: const SizedBox(),
      centerTitle: true,
      title: const Text("Profile", style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfileScreen(userData: userData);
                        },
                      ),
              );
          },
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.defaultSize * 1.6, //16
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
