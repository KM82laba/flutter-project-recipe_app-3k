import 'package:flutter/material.dart';
import 'package:flutter_application_project/components/text.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/models/user.dart';
import 'package:flutter_application_project/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/RecipeBundel.dart';

import '../../../size_config.dart';

class RecipeBundelCard extends StatefulWidget {
  final RecipeCardInfo reciep;
  final void Function() press;
  const RecipeBundelCard({super.key, required this.reciep, required this.press});
  @override
  State<RecipeBundelCard> createState() => _RecipeBundelCardState();
}

class _RecipeBundelCardState extends State<RecipeBundelCard> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String userData = '';

    @override
    void initState() {
      super.initState();
      loadData();
    }

    void loadData() async {
      User? user = await _databaseHelper.getUserById(widget.reciep.user_id);
      if (user != null) {
        setState(() {
          userData = '${user.firstName} ${user.lastName}';
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return GestureDetector(
      onTap: widget.press,
      child:  Center(
          child: Container(
            width: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(
                  widget.reciep.image!,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(0, 0, 0, 0.3), // Semi-transparent black
                    Colors.black.withOpacity(0.7), // Solid black
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 115, // Adjust the height as needed
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 320,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.reciep.title,
                                  style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                  MyText(
                                  text: 'Chef ' + userData,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                SolarIconsOutline.alarm,
                                size: 18,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: widget.reciep.preparation_time.toString(),
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              IconButton.filled(
                                  onPressed: () async {
                                  await _databaseHelper.updateFavoriteStatus(widget.reciep.recipe_id!, !widget.reciep.is_favorite);
                                  setState(() {
                                    widget.reciep.is_favorite =!widget.reciep.is_favorite;
                                  });
                                },
                                icon: Icon(widget.reciep.is_favorite ? SolarIconsBold.bookmark : SolarIconsOutline.bookmark),
                                iconSize: 18,
                                color: AppColors.primaryColor,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }



  Row buildInfoRow(double defaultSize, {required String iconSrc, text}) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(iconSrc),
        SizedBox(width: defaultSize), // 10
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
