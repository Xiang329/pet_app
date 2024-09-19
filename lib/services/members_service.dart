import 'package:pet_app/model/member.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class MembersService {
  static Future<Member> getMemberByEmail(String email) async {
    final response = await ApiService().request(
      ApiUrls.members,
      method: DioMethod.get,
      params: {'email': email},
    );
    return Member.fromJson(response.data);
  }

  static Future<Member> getMemberById(int id) async {
    final response = await ApiService().request(
      '${ApiUrls.members}/$id',
      method: DioMethod.get,
    );
    return Member.fromJson(response.data);
  }

  static Future<void> createMember(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.members,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateMember(
      String email, Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.members,
      method: DioMethod.put,
      params: {'email': email},
      data: data,
    );
  }

  static Future<void> deleteMember(int id) async {
    await ApiService().request(
      '${ApiUrls.members}/$id',
      method: DioMethod.delete,
    );
  }
}
