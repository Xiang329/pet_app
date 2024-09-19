class Breeding {
  int breedingId;
  int breedingMemberId;
  String breedingContent;
  String? breedingComment;
  int breedingPetId;
  String? breedingMobile;

  Breeding({
    required this.breedingId,
    required this.breedingMemberId,
    required this.breedingContent,
    this.breedingComment,
    required this.breedingPetId,
    this.breedingMobile,
  });

  factory Breeding.fromJson(Map<String, dynamic> json) {
    return Breeding(
      breedingId: json['Breeding_ID'],
      breedingMemberId: json['Breeding_MemberID'],
      breedingContent: json['Breeding_Content'],
      breedingComment: json['Breeding_Comment'],
      breedingPetId: json['Breeding_PetID'],
      breedingMobile: json['Breeding_Mobile'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Breeding_ID': breedingId,
        'Breeding_MemberID': breedingMemberId,
        'Breeding_Content': breedingContent,
        'Breeding_Comment': breedingComment,
        'Breeding_PetID': breedingPetId,
        'Breeding_Mobile': breedingMobile,
      };
}
