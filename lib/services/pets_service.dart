import 'package:pet_app/model/pet.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';


class PetsService {
  static Future<Pet> getPetById(int id) async {
    final response = await ApiService().request(
      '${ApiUrls.pets}/$id',
      method: DioMethod.get,
    );

    return Pet.fromJson(response.data);
  }

  static Future<Pet> getPetByCode(String code) async {
    final response = await ApiService().request(
      ApiUrls.pets,
      method: DioMethod.get,
      params: {'code': code},
    );

    return Pet.fromJson(response.data);
  }

  static Future<Pet> createPet(Map<String, dynamic> data) async {
    Pet pet;
    final response = await ApiService().request(
      ApiUrls.pets,
      method: DioMethod.post,
      data: data,
    );

    pet = Pet.fromJson(response.data);
    print(pet.petId);
    return pet;
  }

  static Future<void> updatePet(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.pets}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deletePet(int id) async {
    await ApiService().request(
      '${ApiUrls.pets}/$id',
      method: DioMethod.delete,
    );
  }
}
