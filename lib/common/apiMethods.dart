import 'package:http/http.dart' as http;
import 'dart:convert';

///共用API物件
class ApiMethod {
  dynamic getMethod_ListData(uri) async {
    try {
      print('enter getMethod_ListData');
      String apiUri = "http://35.221.172.90/api/$uri";
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
      String apiUri = "http://35.221.172.90/api/$uri";
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

  dynamic postMethod(uri, submitData) async {
    try {
      print('enter postMethod');
      String apiUri = "http://35.221.172.90/api/$uri";
      print('apiUri : $apiUri');
      print('submitData : $submitData');
      final response = await http.post(
        Uri.parse(apiUri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(submitData),
      );
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  dynamic putMemberMethod(uri, submitData) async {
    print('enter putMethod');
    String apiUri = "http://35.221.172.90/api/$uri";
    print('apiUri : $apiUri');
    print('submitData : $submitData');
    final response = await http.put(
      Uri.parse(apiUri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(submitData),
    );
    print(response.statusCode);
  }

  dynamic putMethod(uri, submitData, id) async {
    print('enter putMethod');
    String apiUri = "http://35.221.172.90/api/$uri/$id";
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
    String apiUri = "http://35.221.172.90/api/$uri/$id";
    print('apiUri : $apiUri');
    await http.delete(
      Uri.parse(apiUri),
      headers: {"Content-Type": "application/json"},
    );
  }
}
