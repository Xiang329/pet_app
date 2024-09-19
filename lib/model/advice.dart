
import 'package:pet_app/model/pet.dart';

class Advice {
  int adviceId;
  int advicePetId;
  String adviceTitle;
  String adviceContent;
  DateTime adviceDateTime;
  String advicePlace;
  Pet? pet;

  Advice({
    required this.adviceId,
    required this.advicePetId,
    required this.adviceTitle,
    required this.adviceContent,
    required this.adviceDateTime,
    required this.advicePlace,
    this.pet,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      adviceId: json['Advice_ID'],
      advicePetId: json['Advice_PetID'],
      adviceTitle: json['Advice_Title'],
      adviceContent: json['Advice_Content'],
      adviceDateTime: DateTime.parse(json['Advice_DateTime']),
      advicePlace: json['Advice_Place'],
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Advice_ID': adviceId,
        'Advice_PetID': advicePetId,
        'Advice_Title': adviceTitle,
        'Advice_Content': adviceContent,
        'Advice_DateTime': adviceDateTime.toIso8601String(),
        'Advice_Place': advicePlace,
        'Pet': pet?.toJson(),
      };
}
