import 'dart:convert';
import 'dart:typed_data';

import 'package:pet_app/model/pet_management.dart';

class Member {
  int memberId;
  String memberEmail;
  String memberName;
  DateTime? memberBirthDay;
  String? memberMobile;
  String memberNickname;
  Uint8List memberMugShot;
  List<PetManagement> petManagementList;

  Member({
    required this.memberId,
    required this.memberEmail,
    required this.memberName,
    this.memberBirthDay,
    this.memberMobile,
    required this.memberNickname,
    required this.memberMugShot,
    required this.petManagementList,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['Member_ID'],
      memberEmail: json['Member_Email'],
      memberName: json['Member_Name'],
      memberBirthDay: json['Member_BirthDay'] != null
          ? DateTime.parse(json['Member_BirthDay'])
          : null,
      memberMobile: json['Member_Mobile'],
      memberNickname: json['Member_Nickname'],
      memberMugShot: base64Decode(json['Member_MugShot'] ?? ''),
      petManagementList: (json['PetManagement'] as List<dynamic>)
          .map((managementJson) => PetManagement.fromJson(managementJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Member_ID': memberId,
        'Member_Email': memberEmail,
        'Member_Name': memberName,
        'Member_BirthDay': memberBirthDay?.toIso8601String(),
        'Member_Mobile': memberMobile,
        'Member_Nickname': memberNickname,
        'Member_MugShot': memberMugShot,
        'PetManagement':
            petManagementList.map((management) => management.toJson()).toList(),
      };
}
