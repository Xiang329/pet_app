import 'package:pet_app/model/pet.dart';

class Medical {
  int medicalId;
  int medicalPetId;
  String? medicalClinic;
  DateTime medicalDate;
  String medicalDisease;
  String? medicalDoctorOrders;
  Pet? pet;

  Medical({
    required this.medicalId,
    required this.medicalPetId,
    this.medicalClinic,
    required this.medicalDate,
    required this.medicalDisease,
    this.medicalDoctorOrders,
    this.pet,
  });

  factory Medical.fromJson(Map<String, dynamic> json) {
    return Medical(
      medicalId: json['Medical_ID'],
      medicalPetId: json['Medical_PetID'],
      medicalClinic: json['Medical_Clinic'] ?? '',
      medicalDate: DateTime.parse(json['Medical_Date']),
      medicalDisease: json['Medical_Disease'],
      medicalDoctorOrders: json['Medical_DoctorOrders'] ?? '',
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Medical_ID': medicalId,
        'Medical_PetID': medicalPetId,
        'Medical_Clinic': medicalClinic,
        'Medical_Date': medicalDate.toIso8601String(),
        'Medical_Disease': medicalDisease,
        'Medical_DoctorOrders': medicalDoctorOrders,
        'Pet': pet?.toJson(),
      };
}
