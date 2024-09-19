import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class MedicalsService {
  static Future<void> createMedical(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.medicals,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateMedical(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.medicals}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteMedical(int id) async {
    await ApiService().request(
      '${ApiUrls.medicals}/$id',
      method: DioMethod.delete,
    );
  }
}
