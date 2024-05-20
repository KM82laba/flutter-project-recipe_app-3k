// ignore_for_file: file_names, avoid_print

import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final String _loggedInKey = 'loggedIn';
  final String _userIdKey = 'id';

  Future<int> register(String username, String password, String firstName, String lastName) async {
    User user = User(username: username, password: password, firstName: firstName, lastName: lastName);
    int id = await _databaseHelper.insert(user);
    return id;
  }

  Future<User?> login(String username, String password) async {
    List<User> users = await _databaseHelper.queryAll();
    print(users);
    for (User user in users) {
      if (user.username == username && user.password == password) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_loggedInKey, true);
        await prefs.setInt(_userIdKey, user.id ?? 0);
        return user;
      }
    }
    throw Exception('Invalid username or password');
  }

  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt(_userIdKey);
    if (userId != null) {
      User? user = await _databaseHelper.getUserById(userId);
      if (user != null) {
        return {
          'username': user.username,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'password': user.password
        };
      }
    }
    return {};
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }
  Future<bool> editProfile(String email, String password, String firstName, String lastName) async {
    try {
      int? userId = await SharedPreferences.getInstance().then((prefs) => prefs.getInt(_userIdKey));
      User user = User(id: userId, username: email, password: password, firstName: firstName, lastName: lastName);
      await _databaseHelper.update(user);
      return true;
    } catch (e) {
      // Обработка ошибки
      print('Error editing profile: $e');
      return false;
    }
  }
}
