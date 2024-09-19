import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class PetManagementsService {
  static Future<PetManagement> getPetManagement(int id) async {
    PetManagement petManagement;
    final response = await ApiService().request(
      '${ApiUrls.petManagements}/$id',
      method: DioMethod.get,
    );

    petManagement = PetManagement.fromJson(response.data);
    // print(petManagement.pmId);
    return petManagement;
  }

  static Future<void> createPetManagement(Map<String, dynamic> data) async {
    PetManagement petManagement;
    final response = await ApiService().request(
      ApiUrls.petManagements,
      method: DioMethod.post,
      data: data,
    );

    petManagement = PetManagement.fromJson(response.data);
    print(petManagement.pmId);
  }

  static Future<void> updatePetManagement(
      int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.petManagements}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deletePetManagement(int id) async {
    await ApiService().request(
      '${ApiUrls.petManagements}/$id',
      method: DioMethod.delete,
    );
  }
}
