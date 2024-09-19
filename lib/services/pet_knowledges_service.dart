import 'package:pet_app/model/pet_knowledge.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class PetKnowledgesService {
  static Future<dynamic> getPetKnowledges() async {
    List<PetKnowledge> articles = [];

    final response = await ApiService().request(
      ApiUrls.petKnowledges,
      method: DioMethod.get,
    );

    articles = List<PetKnowledge>.from(
        (response.data as List).map((e) => PetKnowledge.fromJson(e)));
    return articles;
  }
}
