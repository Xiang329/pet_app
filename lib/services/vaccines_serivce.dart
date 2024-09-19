import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class VaccinesService {
  static Future<void> createVaccine(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.vaccines,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateVaccine(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.vaccines}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteVaccine(int id) async {
    await ApiService().request(
      '${ApiUrls.vaccines}/$id',
      method: DioMethod.delete,
    );
  }
}
