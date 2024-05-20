// ignore_for_file: use_super_parameters, prefer_final_fields, avoid_unnecessary_containers, unnecessary_to_list_in_spreads, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_project/components/text.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/models/user.dart';
import 'package:flutter_application_project/utils/utils.dart';


class ListCardsRecipe extends StatefulWidget {
  final List<RecipeCardInfo> recipes;
  
  const ListCardsRecipe({Key? key, required this.recipes}) : super(key: key);

  @override
  State<ListCardsRecipe> createState() => _ListCardsRecipeState();
}

class _ListCardsRecipeState extends State<ListCardsRecipe> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  
  @override
  Widget build(BuildContext context) {
    const double circleRadius = 130.0;
    const double circleBorderWidth = 8.0;
    return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: widget.recipes.length,
            itemBuilder: (context, index) {
              RecipeCardInfo recipe = widget.recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                              reciep: recipe,
                            )),
                  );
                },
                child: Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: circleRadius / 2.0),
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: const Color.fromRGBO(217, 217, 217, 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  recipe.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const MyText(
                                          text: 'Time',
                                          color: Colors.black38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              SolarIconsOutline.clockCircle,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            MyText(
                                              text: recipe.preparation_time!,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton.filled(
                                      onPressed: () async {
                                        await _databaseHelper.updateFavoriteStatus(
                                            recipe.recipe_id!, !recipe.is_favorite);
                                        setState(() {
                                          recipe.is_favorite = !recipe.is_favorite;
                                        });
                                      },
                                      icon: Icon(recipe.is_favorite
                                          ? SolarIconsBold.bookmark
                                          : SolarIconsOutline.bookmark),
                                      iconSize: 18,
                                      color: AppColors.primaryColor,
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: circleRadius,
                          height: circleRadius,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(32, 32, 32, 0.15),
                                offset: Offset(0, 8),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(circleBorderWidth),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(66, 164, 164, 164),
                                  ),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(
                                    recipe.image!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}


class RecipeDetailPage extends StatefulWidget {
  final RecipeCardInfo reciep;
  const RecipeDetailPage({Key? key, required this.reciep}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> 
  with SingleTickerProviderStateMixin {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  
 late final TabController _tabController;
String userData = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  bool checkTabController() {
    return _tabController.index == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        scrolledUnderElevation: 3,
        title: Text(
          widget.reciep.title,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Center(
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
                                      height: 115,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: SizedBox(
                                            width: 220,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text: widget.reciep.title,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
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
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: AppColors.white,
                              labelPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              indicatorPadding: const EdgeInsets.symmetric(
                                  horizontal: -33, vertical: 8),
                              unselectedLabelColor:
                                  AppColors.secondaryColor,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                color: AppColors.primaryColor,
                              ),
                              tabs: const [
                                Tab(
                                  text: 'Details',
                                ),
                                Tab(
                                  text: ' Procedure',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Description:',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.reciep.description}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            children: [
                            const Text(
                              'Calories',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${widget.reciep.calories} kcal',
                              style: const TextStyle(fontSize: 18),
                            ),
                            ],
                          ),
                          const SizedBox(height: 8, width: 50),
                          Column(
                            children: [
                              const Text(
                                'Weight',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${widget.reciep.weight} g',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8, width: 50),
                          Column(
                            children: [
                          const Text(
                            'Servings',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.reciep.servings}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          ],    
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      widget.reciep.category != null ? 
                      Text(
                        'Category: ${widget.reciep.category}',
                        style: const TextStyle(fontSize: 16),
                      ) : const SizedBox(),
                      const SizedBox(height: 16),
                      const Text(
                        'Ingredients:',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...widget.reciep.ingredients.map((ingredient) {
                        return Row(
                          children: [
                            const Icon(SolarIconsOutline.rollingPin, size: 25),
                            const SizedBox(width: 5),
                            Text(
                              '${ingredient.name} - ${ingredient.quantity} ${ingredient.unit}',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                    ]
                  ),
              )
            ),
            SingleChildScrollView(
              child: StepsListWidget(steps: widget.reciep.steps),
            ),
          ],
        ),
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final int stepNumber;
  final String description;
  final bool isLastStep;

  const StepWidget({
    required this.stepNumber,
    required this.description,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (!isLastStep)
        Row(  
          children: [
              const SizedBox(width: 10),
             Container(
                width: 2,
                height: 30,
                color: Colors.red,
              ),
          ]
        )
             
          ],
        ),  
        const SizedBox(width: 10),
        Column(  
          children: [
            Container(
            
            height: 24,
            decoration: const BoxDecoration(
              
            ),
            child: Center(
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  fontSize: 16,
                ),
              ),
            ),
          ),
            ]
        )
      ],
    );
  }
}


class StepsListWidget extends StatelessWidget {
  final List<RecipeStepCard> steps;

  const StepsListWidget({
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
            padding: const EdgeInsets.all(16.0),
    child : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow the instructions below',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < steps.length; i++)
          StepWidget(
            stepNumber: i + 1,
            description: steps[i].description,
            isLastStep: i == steps.length - 1,
          ),
      ],
    )
    );
  }
}