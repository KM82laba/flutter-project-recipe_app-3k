// ignore_for_file: unnecessary_null_comparison, use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names, must_be_immutable

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/ingredient.dart';
import 'package:flutter_application_project/models/recipe.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/models/recipeIngredient.dart';
import 'package:flutter_application_project/models/recipeStep.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';


class RecipeFormEdit extends StatefulWidget {
  final Function(BuildContext context, Recipe , List<RecipeIngredient> , List<RecipeStep>) onSubmit;
  final Function (BuildContext context) onDelete;
  RecipeCardInfo recipeCardInfo;

  RecipeFormEdit({required this.onSubmit, required this.recipeCardInfo, required this.onDelete});

  @override
  _RecipeFormEditState createState() => _RecipeFormEditState();
}

class _RecipeFormEditState extends State<RecipeFormEdit> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _weightController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final String _userIdKey = 'id';
  Uint8List imageBytes = Uint8List(0);
  List<RecipeIngredient> ingredients = [];
  List<Ingredient> allIngredients = [];
  List<RecipeStep> steps = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Uint8List?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      return await pickedFile.readAsBytes();
    } else {
      return null;
    }
  }
 
  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    else {
      imageBytes = (await pickImageFromGallery())!;
    }
  }
  @override
  void initState() {
    super.initState();
    loadIngredients();
    _titleController.text = widget.recipeCardInfo.title;
    _descriptionController.text = widget.recipeCardInfo.description!;
    imageBytes = widget.recipeCardInfo.image!;
    _caloriesController.text = widget.recipeCardInfo.calories.toString();
    _weightController.text = widget.recipeCardInfo.weight.toString();
    _preparationTimeController.text = widget.recipeCardInfo.preparation_time.toString();
    _servingsController.text = widget.recipeCardInfo.servings.toString();
    for (var step_item in  widget.recipeCardInfo.steps) {
       steps.add(RecipeStep(recipeId: widget.recipeCardInfo.recipe_id, stepNumber: step_item.stepNumber, description: step_item.description));
    }
    for (var ingredient_item in  widget.recipeCardInfo.ingredients) {
       ingredients.add(RecipeIngredient(recipeId: widget.recipeCardInfo.recipe_id, ingredientId: ingredient_item.ingredient_id!, quantity: ingredient_item.quantity , unit: ingredient_item.unit));
    }
  }
  void loadIngredients() async {
    List<Ingredient> ingredientsFromDatabase = await _databaseHelper.queryAllIngredients();
    setState(() {
      allIngredients = ingredientsFromDatabase;
    });
  }
  void addIngredient() {
    setState(() {
      int nextIngredientId = ingredients.length;
      ingredients.add(RecipeIngredient(recipeId: 0, ingredientId: nextIngredientId));
    });
  }

  void addStep() {
    setState(() {
      int nextStepNumber = steps.length + 1;
      steps.add(RecipeStep(description: '', stepNumber: nextStepNumber));
    });
  }

  void removeStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color:  imageBytes.isEmpty ? Colors.red.shade200 :  null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () async {
                await requestPermission();
                Uint8List? imageData = await pickImageFromGallery();
                setState(() {
                  imageBytes = imageData!;
                });
              },
              child: imageBytes.isEmpty
                  ? const Text(
                      'Pick Image',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 82, 70, 70), fontSize: 16),
                    )
                  : Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Title",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.title),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Description",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.description),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _caloriesController,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Calories",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.numbers_rounded),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a calories';
              }
              return null;
            },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _weightController,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Weight",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.set_meal_sharp),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a weight';
              }
              return null;
            },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _preparationTimeController,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Preparation Time",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.timelapse),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _servingsController,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Servings",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.food_bank),
                ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a servings';
              }
              return null;
            },
            ),
          ),
          Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                          child: DropdownButtonFormField<int>(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an ingredient';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Ingredient',
                              isDense: true,
                              errorStyle: const TextStyle(color: Colors.red),
                              errorText: ingredients[index].ingredientId == null ? 'Please select an ingredient' : null,
                            ),
                            isExpanded: true,
                            itemHeight: 50,
                            iconSize: 24,
                            value: ingredients[index].ingredientId,
                            items: allIngredients.map((ingredient) {
                              return DropdownMenuItem<int>(
                                value: ingredient.ingredient_id,
                                child: SizedBox(
                                  height: 30,
                                  child: Text(
                                    ingredient.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                ingredients[index].ingredientId = value!;
                              });
                            },
                          ),
                        ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              initialValue: ingredients[index].quantity.toString(),
                              onChanged: (value) {
                                ingredients[index].quantity = int.parse(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Quantity',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              initialValue: ingredients[index].unit,
                              onChanged: (value) {
                                ingredients[index].unit = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Unit',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: addIngredient,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add Ingredient', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: steps.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: steps[index].description,
                              onChanged: (value) {
                                setState(() {
                                  steps[index].description = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Step ${steps[index].stepNumber}',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              removeStep(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: addStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add step cooking' , style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  int? userId = prefs.getInt(_userIdKey);
                  final recipe = Recipe(
                    userId: userId!,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    image: imageBytes,
                    calories: double.parse(_caloriesController.text),
                    weight: double.parse(_weightController.text),
                    preparationTime: _preparationTimeController.text,
                    servings: int.parse(_servingsController.text),
                  );
                  // ignore: use_build_context_synchronously
                  widget.onSubmit(context ,recipe , ingredients, steps);
                }
                //  List<String> ingredientNames = [
                //   "Sugar",
                //   "Flour",
                //   "Eggs",
                //   "Milk",
                //   "Butter",
                //   "Garlic",
                //   "Onion",
                //   "Tomato",
                //   "Basil",
                //   "Oregano",
                //   "Thyme",
                //   "Rosemary",
                //   "Cinnamon",
                //   "Nutmeg",
                //   "Ginger",
                //   "Lemon",
                //   "Honey",
                //   "Vanilla",
                //   "Paprika",
                //   "Cumin",
                //   "Chili Powder",
                //   "Coriander",
                //   "Soy Sauce",
                //   "Worcestershire Sauce",
                //   "Vinegar",
                //   "Mustard",
                //   "Ketchup",
                //   "Mayonnaise",
                //   "Olive Oil",
                //   "Vegetable Oil",
                //   "Sesame Oil",
                //   "Rice",
                //   "Pasta",
                //   "Quinoa",
                //   "Beans",
                //   "Lentils",
                //   "Chickpeas",
                // ];

                // for (String name in ingredientNames) {
                //   Ingredient ingredient = Ingredient(name: name);
                //   int id = await _databaseHelper.insertIngredient(ingredient);
                //   print("Ingredient $name inserted with ID: $id");
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 239, 120),
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20, height: 20,),
          ElevatedButton(
              onPressed: () async {
                
                widget.onDelete(context);
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],)
        ],
      ),
    )
    );
  }
}