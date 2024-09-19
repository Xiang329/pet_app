
import 'package:pet_app/model/pet.dart';

class Diet {
  int dietId;
  int dietPetId;
  DateTime dietDateTime;
  double? dietQuantity;
  String? dietSituation;
  Pet? pet;

  Diet({
    required this.dietId,
    required this.dietPetId,
    required this.dietDateTime,
    this.dietQuantity,
    this.dietSituation,
    this.pet,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      dietId: json['Diet_ID'],
      dietPetId: json['Diet_PetID'],
      dietDateTime: DateTime.parse(json['Diet_DateTimw']), // Diet_DateTime?
      dietQuantity: json['Diet_Quantity']?.toDouble(),
      dietSituation: json['Diet_Situation'] ?? '',
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Diet_ID': dietId,
        'Diet_PetID': dietPetId,
        'Diet_DateTime': dietDateTime.toIso8601String(),
        'Diet_Quantity': dietQuantity,
        'Diet_Situation': dietSituation,
        'Pet': pet?.toJson(),
      };
}
