import 'dart:convert';
import 'dart:typed_data';

import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';

class Finding {
  int findingId;
  int findingMemberId;
  bool findingLostOrFound;
  String findingContent;
  DateTime findingDateTime;
  String findingPlace;
  Uint8List findingImage;
  int? findingPetId;
  int? findingPC;
  int? findingPV;
  String varietyName;
  String className;
  bool? findingSex;
  String? findingMobile;

  Finding({
    required this.findingId,
    required this.findingMemberId,
    required this.findingLostOrFound,
    required this.findingContent,
    required this.findingDateTime,
    required this.findingPlace,
    required this.findingImage,
    this.findingPetId,
    this.findingPC,
    this.findingPV,
    required this.varietyName,
    required this.className,
    this.findingSex,
    this.findingMobile,
  });

  factory Finding.fromJson(Map<String, dynamic> json) {
    return Finding(
      findingId: json['Finding_ID'],
      findingMemberId: json['Finding_MemberID'],
      findingLostOrFound: json['Finding_LostOrFound'],
      findingContent: json['Finding_Content'],
      findingDateTime: DateTime.parse(json['Finding_DataTime']),
      findingPlace: json['Finding_Place'],
      findingImage: base64Decode(json['Finding_Image'] ?? ''),
      findingPetId: json['Finding_PetID'],
      findingPC: json['Finding_PC'],
      findingPV: json['Finding_PV'],
      varietyName: json['Finding_PV'] == null
          ? '未知種類'
          : PetVarietiesService
              .petVarietyMap[json['Finding_PV']]!.pvVarietyName,
      className: json['Finding_PC'] == null
          ? '未知類別'
          : PetClassesService.petClassesMap[json['Finding_PC']]!,
      findingSex: json['Finding_Sex'],
      findingMobile: json['Finding_Mobile'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Finding_ID': findingId,
        'Finding_MemberID': findingMemberId,
        'Finding_LostOrFound': findingLostOrFound,
        'Finding_Content': findingContent,
        'Finding_DataTime': findingDateTime.toIso8601String(),
        'Finding_Place': findingPlace,
        'Finding_Image': findingImage,
        'Finding_PetID': findingPetId,
      };
}
