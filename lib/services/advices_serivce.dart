import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class AdvicesService {
  static Future<void> createAdvice(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.advices,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateAdvice(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.advices}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteAdvice(int id) async {
    await ApiService().request(
      '${ApiUrls.advices}/$id',
      method: DioMethod.delete,
    );
  }
}
