import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class DrugsService {
  static Future<void> createDrug(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.drugs,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateDrug(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.drugs}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteDrug(int id) async {
    await ApiService().request(
      '${ApiUrls.drugs}/$id',
      method: DioMethod.delete,
    );
  }
}
