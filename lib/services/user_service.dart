import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/models/authorization_model.dart';
import '../models/user_model.dart';

class UserService{

  Future<List<User>> fetchUsers([String? id='']) async {
    var url = 'http://10.0.2.2:8000/backend/users/$id';

    final response = await http
        .get(Uri.parse(url));


    if (response.statusCode == 200) {
      if (id == ''){
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => User.fromJson(user)).toList();

      }
      var test = User.fromJson(jsonDecode(response.body));
      return [test];
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/backend/users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }


  Future<Authorization> authUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/backend/authorize'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {

      return Authorization.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to authorize user.');
    }
  }

}