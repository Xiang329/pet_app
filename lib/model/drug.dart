
import 'package:pet_app/model/pet.dart';

class Drug {
  int drugId;
  int drugPetId;
  String drugName;
  double? drugDosage;
  DateTime drugDate;
  DateTime drugNextDate;
  Pet? pet;

  Drug({
    required this.drugId,
    required this.drugPetId,
    required this.drugName,
    this.drugDosage,
    required this.drugDate,
    required this.drugNextDate,
    this.pet,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      drugId: json['Drug_ID'],
      drugPetId: json['Drug_PetID'],
      drugName: json['Drug_Name'],
      drugDosage: json['Drug_Dosage']?.toDouble(),
      drugDate: DateTime.parse(json['Drug_Date']),
      drugNextDate: DateTime.parse(json['Drug_NextDate']),
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Drug_ID': drugId,
        'Drug_PetID': drugPetId,
        'Drug_Name': drugName,
        'Drug_Dosage': drugDosage,
        'Drug_Date': drugDate.toIso8601String(),
        'Drug_NextDate': drugNextDate.toIso8601String(),
        'Pet': pet?.toJson(),
      };
}
