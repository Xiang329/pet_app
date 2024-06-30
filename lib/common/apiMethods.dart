import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pet_app/models/member.dart';

///共用API物件
class ApiMethod {
  static const String baseUrl = 'http://34.81.244.36/api';

  Future getMethod_Member(email) async {
    try {
      String apiUri = "$baseUrl/Members/?email=$email";
      final response = await http.get(Uri.parse(apiUri));
      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);
        return Member.fromJson(result);
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic getMethod_ListData(uri) async {
    try {
      print('enter getMethod_ListData');
      String apiUri = "$baseUrl/$uri";
      print('apiUri : $apiUri');
      final response = await http.get(Uri.parse(apiUri));
      print(response.statusCode);
      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic getMethod_SingleData(uri) async {
    try {
      print('enter getMethod_SingleData');
      String apiUri = "$baseUrl/$uri";
      // String apiUri = "http://35.221.172.90/api/$uri";
      print('apiUri : $apiUri');
      final response = await http.get(Uri.parse(apiUri));
      print(response.statusCode);
      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }

  Future postMethod(uri, submitData) async {
    try {
      print('enter postMethod');
      String apiUri = "$baseUrl/$uri";
      print('apiUri : $apiUri');
      print('submitData : $submitData');
      final response = await http.post(
        Uri.parse(apiUri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(submitData),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        dynamic result = json.decode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic putMethod_Member(email, submitData) async {
    print('enter putMethod');
    String apiUri = "$baseUrl/Members/?email=$email";
    print('apiUri : $apiUri');
    print('submitData : $submitData');
    final response = await http.put(
      Uri.parse(apiUri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(submitData),
    );
    print(response.statusCode);
  }

  dynamic putMethod(uri, id, submitData) async {
    print('enter putMethod');
    String apiUri = "$baseUrl/$uri/$id";
    print('apiUri : $apiUri');
    print('submitData : $submitData');
    await http.put(
      Uri.parse(apiUri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(submitData),
    );
  }

  dynamic deleteMethod(uri, id) async {
    print('enter deleteMethod');
    String apiUri = "$baseUrl/$uri/$id";
    print('apiUri : $apiUri');
    final response = await http.delete(
      Uri.parse(apiUri),
      headers: {"Content-Type": "application/json"},
    );
  }
}
