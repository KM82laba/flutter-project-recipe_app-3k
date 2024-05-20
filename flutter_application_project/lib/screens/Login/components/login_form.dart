// ignore_for_file: unused_import, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_application_project/components/my_bottom_nav_bar.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/user.dart';
import 'package:flutter_application_project/screens/home/home_screen.dart';
import 'package:flutter_application_project/services/AuthService.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
 const LoginForm({super.key});

 @override
 _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
 final _formKey = GlobalKey<FormState>();
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final AuthService _authService = AuthService();

 @override
 Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                 _formKey.currentState!.save();
                 String email = _emailController.text;
                 String password = _passwordController.text;
                 User? user = await _authService.login(email, password);
                 if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MyBottomNavBar();
                        },
                      ),
                    );
                 } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed')),
                    );
                 }
                }
              },
              child: Text(
                "Login".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                 builder: (context) {
                    return const SignUpScreen();
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
