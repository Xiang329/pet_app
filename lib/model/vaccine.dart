
import 'package:pet_app/model/pet.dart';

class Vaccine {
  int vaccineId;
  int vaccinePetId;
  DateTime vaccineDate;
  String vaccineName;
  DateTime? vaccineNextDate;
  bool vaccineReaction;
  String? vaccineSymptom;
  Pet? pet;

  Vaccine({
    required this.vaccineId,
    required this.vaccinePetId,
    required this.vaccineDate,
    required this.vaccineName,
    this.vaccineNextDate,
    required this.vaccineReaction,
    this.vaccineSymptom,
    this.pet,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      vaccineId: json['Vaccine_ID'],
      vaccinePetId: json['Vaccine_PetID'],
      vaccineDate: DateTime.parse(json['Vaccine_Date']),
      vaccineName: json['Vaccine_Name'],
      vaccineNextDate: json['Vaccine_NextDate'] == null
          ? null
          : DateTime.parse(json['Vaccine_NextDate']),
      vaccineReaction: json['Vaccine_reaction'],
      vaccineSymptom: json['Vaccine_symptom'] ?? '',
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Vaccine_ID': vaccineId,
        'Vaccine_PetID': vaccinePetId,
        'Vaccine_Date': vaccineDate.toIso8601String(),
        'Vaccine_Name': vaccineName,
        'Vaccine_NextDate': vaccineNextDate?.toIso8601String(),
        'Vaccine_reaction': vaccineReaction,
        'Vaccine_symptom': vaccineSymptom,
        'Pet': pet?.toJson(),
      };
}
