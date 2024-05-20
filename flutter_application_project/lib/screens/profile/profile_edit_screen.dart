// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_project/screens/profile/prrofile_screen.dart';
import 'package:flutter_application_project/services/AuthService.dart';
import 'package:flutter_application_project/utils/utils.dart';
import '../../constants.dart';
import '../../size_config.dart';

class EditProfileScreen extends StatelessWidget {
  final Map<String, String?> userData;

  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: BodyEditProfileScreen(userData: userData),
    );
  }

 AppBar buildAppBar(context) {
  return AppBar(
    backgroundColor: kPrimaryColor,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    title: const Text(
      "Edit profile",
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
}

class BodyEditProfileScreen extends StatefulWidget {
  final Map<String, String?> userData;
  const BodyEditProfileScreen({Key? key, required this.userData}) : super(key: key);
  @override
  _BodyEditProfileScreenState createState() => _BodyEditProfileScreenState();
}
class _BodyEditProfileScreenState extends State<BodyEditProfileScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.userData['username'] ?? '');
    _passwordController = TextEditingController(text: widget.userData['password'] ?? '');
    _firstNameController = TextEditingController(text: widget.userData['firstName'] ?? '');
    _lastNameController = TextEditingController(text: widget.userData['lastName'] ?? '');
  }

  @override
  Widget build(BuildContext context) {

    return Container( 
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Your username",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(
                        SolarIconsOutline.mentionSquare,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
                  child: TextFormField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(SolarIconsOutline.userId),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
                  child: TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(SolarIconsOutline.userId,),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
                  child: TextFormField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: "Your password",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(
                          SolarIconsOutline.keyMinimalisticSquare,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        // Call the edit profile function instead of register
                        bool success = await AuthService().editProfile(email, password, firstName, lastName);
                        if (success) {
                          // Profile editing successful, navigate user to profile screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ProfileScreen();
                              },
                            ),
                          );
                        } else {
                          // Handle editing error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile editing failed')),
                          );
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Edit profile".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
    );
  }
}
