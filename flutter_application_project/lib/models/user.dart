class User {
  final int? id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;

 User({this.id, required this.username, required this.password , required this.firstName, required this.lastName});

 int? get getId => id;

 Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName
    };
    return map;
 }
}
