// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/screens/ReciepList/components/list_recieps.dart';
import 'package:flutter_application_project/screens/profile/components/list_recieps.dart';
import '../../size_config.dart';
import 'package:flutter_application_project/utils/utils.dart';

class ListFavReciepScreen extends StatelessWidget {
  const ListFavReciepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListFavCardsRecipe(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: Icon(SolarIconsOutline.arrowLeft, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text("Saved Recipes", style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold)),
    );
  }

}
