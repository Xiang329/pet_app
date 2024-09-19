import 'dart:convert';
import 'dart:typed_data';

import 'package:pet_app/model/advice.dart';
import 'package:pet_app/model/diet.dart';
import 'package:pet_app/model/drug.dart';
import 'package:pet_app/model/excretion.dart';
import 'package:pet_app/model/medical.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/model/vaccine.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';

class Pet {
  int petId;
  String petICID;
  String petName;
  DateTime? petBirthDay;
  int petAge;
  bool petSex;
  int petVariety;
  double petWeight;
  bool petLigation;
  String petBlood;
  Uint8List petMugShot;
  String petInvCode;
  String varietyName;
  String className;
  List<Advice> adviceList;
  List<Diet> dietList;
  List<Drug> drugList;
  List<Excretion> excretionList;
  List<Medical> medicalList;
  List<PetManagement> petManagementList;
  List<Vaccine> vaccineList;

  Pet({
    required this.petId,
    required this.petICID,
    required this.petName,
    this.petBirthDay,
    required this.petAge,
    required this.petSex,
    required this.petVariety,
    required this.petWeight,
    required this.petLigation,
    required this.petBlood,
    required this.petMugShot,
    required this.petInvCode,
    required this.varietyName,
    required this.className,
    required this.adviceList,
    required this.dietList,
    required this.drugList,
    required this.excretionList,
    required this.medicalList,
    required this.petManagementList,
    required this.vaccineList,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['Pet_ID'],
      petICID: json['Pet_ICID'],
      petName: json['Pet_Name'],
      petBirthDay: json['Pet_BirthDay'] == null
          ? null
          : DateTime.parse(json['Pet_BirthDay']),
      petAge: json['Pet_Age'],
      petSex: json['Pet_Sex'],
      petVariety: json['Pet_Variety'],
      petWeight: json['Pet_Weight'],
      petLigation: json['Pet_Ligation'],
      petBlood: json['Pet_Blood'],
      petMugShot: base64Decode(json['Pet_MugShot'] ?? ''),
      petInvCode: json['Pet_InvCode'],
      varietyName: PetVarietiesService
              .petVarietyMap[json['Pet_Variety']]?.pvVarietyName ??
          ' ',
      className: PetClassesService.petClassesMap[
              PetVarietiesService.getClassId(json['Pet_Variety'])] ??
          ' ',
      adviceList: (json['Advice'] as List<dynamic>)
          .map((adviceJson) => Advice.fromJson(adviceJson))
          .toList(),
      dietList: (json['Diet'] as List<dynamic>)
          .map((dietJson) => Diet.fromJson(dietJson))
          .toList(),
      drugList: (json['Drug'] as List<dynamic>)
          .map((drugJson) => Drug.fromJson(drugJson))
          .toList(),
      excretionList: (json['Excretion'] as List<dynamic>)
          .map((excretionJson) => Excretion.fromJson(excretionJson))
          .toList(),
      medicalList: (json['Medical'] as List<dynamic>)
          .map((medicalJson) => Medical.fromJson(medicalJson))
          .toList(),
      petManagementList: (json['PetManagement'] as List<dynamic>)
          .map((petManagementJson) => PetManagement.fromJson(petManagementJson))
          .toList(),
      vaccineList: (json['Vaccine'] as List<dynamic>)
          .map((vaccineJson) => Vaccine.fromJson(vaccineJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Pet_ID': petId,
        'Pet_ICID': petICID,
        'Pet_Name': petName,
        'Pet_BirthDay': petBirthDay?.toIso8601String(),
        'Pet_Age': petAge,
        'Pet_Sex': petSex,
        'Pet_Variety': petVariety,
        'Pet_Weight': petWeight,
        'Pet_Ligation': petLigation,
        'Pet_Blood': petBlood,
        'Pet_MugShot': petMugShot,
        'Pet_InvCode': petInvCode,
        'Advice': adviceList.map((advice) => advice.toJson()).toList(),
        'Diet': dietList.map((diet) => diet.toJson()).toList(),
        'Drug': drugList.map((drug) => drug.toJson()).toList(),
        'Excretion':
            excretionList.map((excretion) => excretion.toJson()).toList(),
        'Medical': medicalList.map((medical) => medical.toJson()).toList(),
        'PetManagement':
            petManagementList.map((management) => management.toJson()).toList(),
        'Vaccine': vaccineList.map((vaccine) => vaccine.toJson()).toList(),
      };
}
