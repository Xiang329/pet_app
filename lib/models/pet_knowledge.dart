class PetKnowledge {
  int pkId;
  int pcId;
  int pvId;
  int pkPetAge;
  double pkPetWeight;
  String pkProposalContent;
  String className;

  PetKnowledge({
    required this.pkId,
    required this.pcId,
    required this.pvId,
    required this.pkPetAge,
    required this.pkPetWeight,
    required this.pkProposalContent,
    required this.className,
  });

  factory PetKnowledge.fromJson(Map<String, dynamic> json) {
    return PetKnowledge(
      pkId: json['PK_ID'],
      pcId: json['PC_ID'],
      pvId: json['PV_ID'],
      pkPetAge: json['PK_PetAge'],
      pkPetWeight: json['PK_PetWeight'],
      pkProposalContent: json['PK_ProposalContent'],
      className: json['PetClass']['PC_ClassName'],
    );
  }
}
