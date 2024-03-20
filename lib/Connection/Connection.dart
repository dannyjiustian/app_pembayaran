import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Auth/Login.dart';
import '../Models/DetailTransaction/DetailTransaction.dart';
import '../Models/ListCard/ListCard.dart';
import '../Models/ListTransaction/ListTransaction.dart';
import '../Models/TokenJWT/TokenJWT.dart';

class Connection {
  final String url = "http://192.168.100.75:3000/api/v1/";

  _setHeaders(String token) => {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future checkRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getString('refreshToken');
  }

  Future refreshTokenAction() async {
    try {
      Uri uri = Uri.parse("${url}refresh-token");
      String? refreshToken = await checkRefreshToken();
      final response = await http.get(
        uri,
        headers: _setHeaders(refreshToken.toString()),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        TokenJWT tokenJWT = TokenJWT.fromJson(data);
        final pref = await SharedPreferences.getInstance();
        pref.setString("accessToken", tokenJWT.data!.accessToken);
        pref.setString("refreshToken", tokenJWT.data!.refreshToken);
        print("new " + tokenJWT.data!.accessToken);
        return tokenJWT.data!.accessToken;
      } else {
        throw Exception("1");
      }
    } catch (e) {
      if (e.toString() == "Exception: 1") {
        return null;
      } else {
        Map<String, dynamic> data =
            (json.decode('{"status": false, "message": "${e.toString()}"}')
                as Map<String, dynamic>);
        return TokenJWT.fromJson(data);
      }
    }
  }

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
        return Login.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return Login.fromJson(data);
    }
  }

  Future updateAction(String token, Object body) async {
    try {
      Uri uri = Uri.parse("${url}update");
      final response = await http.put(
        uri,
        body: body,
        headers: _setHeaders(token),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return Login.fromJson(data);
      } else if (response.statusCode == 401) {
        String? newToken = await refreshTokenAction();
        if (newToken != null) {
          return updateAction(newToken, body);
        } else {
          return Login(
              status: false, message: "refresh token verification failed");
        }
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

  Future getCardByIDUser(String token, String id_user) async {
    try {
      Uri uri = Uri.parse("${url}card/id-user/${id_user}");
      final response = await http.get(
        uri,
        headers: _setHeaders(token),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return ListCard.fromJson(data);
      } else if (response.statusCode == 401) {
        String? newToken = await refreshTokenAction();
        if (newToken != null) {
          return getCardByIDUser(newToken, id_user);
        } else {
          return ListCard(
              status: false, message: "refresh token verification failed");
        }
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

  Future getTransasctionByIDUser(String token, String id_user,
      {int? take, bool? status}) async {
    try {
      String urlQuery = "${url}transaction/id-user/$id_user";

      if (take != null) {
        urlQuery += "?take=$take";
        if (status != null) urlQuery += "&status=$status";
      } else if (status != null) {
        urlQuery += "?status=$status";
      }
      Uri uri = Uri.parse(urlQuery);
      final response = await http.get(
        uri,
        headers: _setHeaders(token),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return ListTransaction.fromJson(data);
      } else if (response.statusCode == 401) {
        String? newToken = await refreshTokenAction();
        if (newToken != null) {
          return getTransasctionByIDUser(newToken, id_user,
              take: take, status: status);
        } else {
          return ListTransaction(
              status: false, message: "refresh token verification failed");
        }
      } else {
        return ListTransaction.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return ListTransaction.fromJson(data);
    }
  }

  Future getTransasctionByIDTransaction(String token, String id_transaction,
      {bool? status}) async {
    try {
      String urlQuery = "${url}transaction/$id_transaction";
      if (status != null) urlQuery += "?status=$status";
      Uri uri = Uri.parse(urlQuery);
      final response = await http.get(
        uri,
        headers: _setHeaders(token),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return DetailTransaction.fromJson(data);
      } else if (response.statusCode == 401) {
        String? newToken = await refreshTokenAction();
        if (newToken != null) {
          return getTransasctionByIDTransaction(newToken, id_transaction,
              status: status);
        } else {
          return DetailTransaction(
              status: false, message: "refresh token verification failed");
        }
      } else {
        return DetailTransaction.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return DetailTransaction.fromJson(data);
    }
  }

  Future cancelTransaction(String token, String id_transaction) async {
    try {
      Uri uri = Uri.parse("${url}transaction/cancel/$id_transaction");
      final response = await http.put(
        uri,
        headers: _setHeaders(token),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>);
      if (response.statusCode == 200) {
        return DetailTransaction.fromJson(data);
      } else if (response.statusCode == 401) {
        String? newToken = await refreshTokenAction();
        if (newToken != null) {
          return cancelTransaction(newToken, id_transaction);
        } else {
          return DetailTransaction(
              status: false, message: "refresh token verification failed");
        }
      } else {
        return DetailTransaction.fromJson(data);
      }
    } catch (e) {
      Map<String, dynamic> data =
          (json.decode('{"status": false, "message": "${e.toString()}"}')
              as Map<String, dynamic>);
      return DetailTransaction.fromJson(data);
    }
  }
}
