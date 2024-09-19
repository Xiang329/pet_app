import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class DietsService {
  static Future<void> createDiet(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.diets,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateDiet(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.diets}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteDiet(int id) async {
    await ApiService().request(
      '${ApiUrls.diets}/$id',
      method: DioMethod.delete,
    );
  }
}
