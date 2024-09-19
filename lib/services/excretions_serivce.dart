import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class ExcretionsService {
  static Future<void> createExcretion(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.excretions,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateExcretion(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.excretions}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteExcretion(int id) async {
    await ApiService().request(
      '${ApiUrls.excretions}/$id',
      method: DioMethod.delete,
    );
  }
}
