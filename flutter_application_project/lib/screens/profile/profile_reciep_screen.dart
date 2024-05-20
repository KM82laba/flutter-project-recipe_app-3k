// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/screens/profile/profile_edit_reciep_screen.dart';
import 'package:flutter_application_project/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../size_config.dart';


class ProfileListRecieps extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final String _userIdKey = 'id';

  ProfileListRecieps({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<RecipeCardInfo>>(
        future: getUserRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<RecipeCardInfo>? recipes = snapshot.data;
            return ListView.builder(
            itemCount: recipes!.length,
            itemBuilder: (context, index) {
              return Container(
                height: 105,
                child: ListTile(
                  leading: Image.memory(
                    recipes[index].image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(recipes[index].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      const Icon(SolarIconsOutline.clockCircle, color: kPrimaryColor, size: 20),
                      const SizedBox(width: 5),
                      Text(recipes[index].preparation_time?? 'N/A'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileEditReciep(recipeCardInfo: recipes[index]);
                        }
                      )
                    );
                  },
                ),
              );
            },
          );
          }
        },
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: const Icon(SolarIconsOutline.arrowLeft, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text(
        "My recipes",
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<List<RecipeCardInfo>> getUserRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt(_userIdKey);
    return await _databaseHelper.getUserRecipes(userId!);
  }
}
