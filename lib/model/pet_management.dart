
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/pet.dart';

class PetManagement {
  int pmId;
  int pmMemberId;
  int pmPetId;
  String pmPermissions;
  Member? member;
  Pet? pet;

  PetManagement({
    required this.pmId,
    required this.pmMemberId,
    required this.pmPetId,
    required this.pmPermissions,
    this.member,
    this.pet,
  });

  factory PetManagement.fromJson(Map<String, dynamic> json) {
    return PetManagement(
      pmId: json['PM_ID'],
      pmMemberId: json['PM_MemberID'],
      pmPetId: json['PM_PetID'],
      pmPermissions: json['PM_Permissions'],
      member: json['Member'] == null ? null : Member.fromJson(json['Member']),
      pet: json['Pet'] == null ? null : Pet.fromJson(json['Pet']),
    );
  }

  Map<String, dynamic> toJson() => {
        'PM_ID': pmId,
        'PM_MemberID': pmMemberId,
        'PM_PetID': pmPetId,
        'PM_Permissions': pmPermissions,
        'Member': member?.toJson(),
        'Pet': pet?.toJson(),
      };
}
