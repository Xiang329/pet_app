import 'package:pet_app/model/pet_class.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class PetClassesService {
  static final Map<int, String> _petClassesMap = {};
  static Map<int, String> get petClassesMap => _petClassesMap;

  static Future<void> getPetClasses() async {
    final response = await ApiService().request(
      ApiUrls.petClasses,
      method: DioMethod.get,
    );

    final List<dynamic> data = response.data;
    for (var item in data) {
      PetClass petClass = PetClass.fromJson(item);
      if (petClass.pcClassName.isNotEmpty) {
        _petClassesMap[petClass.pcId] = petClass.pcClassName;
      }
    }
  }
}
