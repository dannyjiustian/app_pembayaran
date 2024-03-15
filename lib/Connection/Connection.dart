import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/Auth/Login.dart';
import '../Models/ListCard/ListCard.dart';

class Connection {
  final String url = "http://192.168.100.75:3000/api/v1/";

  Future loginAction(String username, String password) async {
    try {
      Uri uri = Uri.parse("${url}login");
      final response = await http.post(uri, body: {
        "username": username,
        "password": password,
      });
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return Login.fromJson(data);
      } else {
        return Login.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return Login.fromJson(data);
    }
  }

  Future resetAction(String username, String email, String password) async {
    try {
      Uri uri = Uri.parse("${url}reset");
      final response = await http.post(uri, body: {
        "email": email,
        "username": username,
        "password": password,
      });
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return Login.fromJson(data);
      } else {
        return Login.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return Login.fromJson(data);
    }
  }

  Future registerAction(String name, String username, String email,
      String password, String? role) async {
    try {
      Uri uri = Uri.parse("${url}register");
      final response = await http.post(uri, body: {
        "name": name,
        "email": email,
        "username": username,
        "password": password,
        "role": role,
      });
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return Login.fromJson(data);
      } else {
        print(data);
        return Login.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return Login.fromJson(data);
    }
  }

  Future getCardByID(String? id_user) async {
    try {
      Uri uri = Uri.parse("${url}card/id-user/${id_user}");
      final response = await http.get(uri);
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return ListCard.fromJson(data);
      } else {
        return ListCard.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return ListCard.fromJson(data);
    }
  }
}
