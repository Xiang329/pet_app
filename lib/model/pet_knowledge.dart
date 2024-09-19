import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';

class PetKnowledge {
  int pkId;
  int pcId;
  int pvId;
  int pkPetAge;
  double pkPetWeight;
  String pkProposalContent;
  String pkTitle;
  String className;
  String varietyName;

  PetKnowledge({
    required this.pkId,
    required this.pcId,
    required this.pvId,
    required this.pkPetAge,
    required this.pkPetWeight,
    required this.pkProposalContent,
    required this.pkTitle,
    required this.className,
    required this.varietyName,
  });

  factory PetKnowledge.fromJson(Map<String, dynamic> json) {
    return PetKnowledge(
      pkId: json['PK_ID'],
      pcId: json['PC_ID'],
      pvId: json['PV_ID'],
      pkPetAge: json['PK_PetAge'],
      pkPetWeight: json['PK_PetWeight'],
      pkProposalContent: json['PK_ProposalContent'],
      pkTitle: json['PK_Title'],
      className: PetClassesService.petClassesMap[json['PC_ID']] ?? '',
      varietyName:
          PetVarietiesService.petVarietyMap[json['PV_ID']]?.pvVarietyName ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PK_ID': pkId,
      'PC_ID': pcId,
      'PV_ID': pvId,
      'PK_PetAge': pkPetAge,
      'PK_PetWeight': pkPetWeight,
      'PK_ProposalContent': pkProposalContent,
      'PK_Title': pkTitle,
    };
  }
}
