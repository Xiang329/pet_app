import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pet_app/models/member.dart';

class UserService {
  static Future<Member> feachUserData(String email) async {
    print("發送");
    var url = Uri.parse("http://35.221.172.90/api/Members/?email=$email");
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Future.delayed(
          const Duration(seconds: 1), () => Member.fromJson(body));
      // return Member.fromJson(body);
    }
    throw Exception('Failed to load data');
  }

  static Future<void> putSinglePost(String email, submitData) async {
    print("發送");
    var url = Uri.parse("http://35.221.172.90/api/Members/?email=$email");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(submitData),
    );
    print(response.statusCode);
  }

  static Future<FakeUser> getFakeData() async {
    print("發送");
    var url = Uri.parse("https://randomuser.me/api/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body)['results'][0];
      return Future.delayed(
          const Duration(seconds: 2), () => FakeUser.fromJson(body));
    }
    throw Exception('Failed to load data');
  }
}

class FakeUser {
  int? memberId;
  String? memberEmail;
  String? memberName;
  String? memberMobile;

  FakeUser({
    this.memberEmail,
    this.memberName,
    this.memberMobile,
  });

  factory FakeUser.fromJson(Map<String, dynamic> json) {
    return FakeUser(
      memberEmail: json['email'],
      memberName: json['name']['title'],
      memberMobile: json['phone'],
    );
  }

  Map<String, dynamic> getAllValues() {
    return {
      'memberEmail': memberEmail,
      'memberName': memberName,
      'memberMobile': memberMobile,
    };
  }
}
