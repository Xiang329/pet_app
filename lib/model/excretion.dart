import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pet_app/model/pet.dart';

class Excretion {
  int excretionId;
  int excretionPetId;
  DateTime excretionDateTime;
  String? excretionSituation;
  Uint8List excretionPicture;
  Pet? pet;

  Excretion({
    required this.excretionId,
    required this.excretionPetId,
    required this.excretionDateTime,
    this.excretionSituation,
    required this.excretionPicture,
    this.pet,
  });

  factory Excretion.fromJson(Map<String, dynamic> json) {
    return Excretion(
      excretionId: json['Excretion_ID'],
      excretionPetId: json['Excretion_PetID'],
      excretionDateTime: DateTime.parse(json['Excretion_DateTime']),
      excretionSituation: json['Excretion_Situation'] ?? '',
      excretionPicture: base64Decode(json['Excretion_Picture'] ?? ''),
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Excretion_ID': excretionId,
        'Excretion_PetID': excretionPetId,
        'Excretion_DateTime': excretionDateTime.toIso8601String(),
        'Excretion_Situation': excretionSituation,
        'Excretion_Picture': excretionPicture,
        'Pet': pet?.toJson(),
      };
}
