import 'package:pet_app/model/pet_variety.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class PetVarietiesService {
  static final Map<int, PetVariety> _petVarietyMap = {};
  static Map<int, PetVariety> get petVarietyMap => _petVarietyMap;

  static final Map<int, List<String>> _petVarietyMapByPcId = {};
  static Map<int, List<String>> get petVarietyMapByPcId => _petVarietyMapByPcId;

  static Future<void> getPetVarieties() async {
    final response = await ApiService().request(
      ApiUrls.petVarieties,
      method: DioMethod.get,
    );

    final List<dynamic> data = response.data;
    for (var item in data) {
      PetVariety petVariety = PetVariety.fromJson(item);
      _petVarietyMap[petVariety.pvId] = petVariety;
    }

    // 將寵物品種按寵物類別ID進行分組
    for (var petVariety in _petVarietyMap.values) {
      if (!_petVarietyMapByPcId.containsKey(petVariety.pcId)) {
        _petVarietyMapByPcId[petVariety.pcId] = [];
      }
      _petVarietyMapByPcId[petVariety.pcId]?.add(petVariety.pvVarietyName);
    }
  }

  static int? getClassId(int id) {
    return _petVarietyMap[id]?.pcId;
  }
}
