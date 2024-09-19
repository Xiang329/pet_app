import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class BreedingsService {
  static Future<List<Breeding>> getBreedings() async {
    List<Breeding> breedings = [];

    final response = await ApiService().request(
      ApiUrls.breedings,
      method: DioMethod.get,
    );

    breedings = List<Breeding>.from(
        (response.data as List).map((e) => Breeding.fromJson(e)));
    return breedings;
  }

  static Future<dynamic> getBreedingById(int id) async {
    Breeding breeding;

    final response = await ApiService().request(
      '${ApiUrls.breedings}/$id',
      method: DioMethod.get,
    );

    breeding = Breeding.fromJson(response.data);
    return breeding;
  }

  static Future<List<Breeding>> getBreedingsByMemberId(int memberId) async {
    List<Breeding> breedings = [];

    final response = await ApiService().request(
      ApiUrls.breedings,
      method: DioMethod.get,
      params: {'member_id': memberId},
    );

    breedings = List<Breeding>.from(
        (response.data as List).map((e) => Breeding.fromJson(e)));
    return breedings;
  }

  static Future<void> createBreeding(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.breedings,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateBreeding(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.breedings}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteBreeding(int id) async {
    await ApiService().request(
      '${ApiUrls.breedings}/$id',
      method: DioMethod.delete,
    );
  }
}
