class Member {
  int? memberId;
  String? memberEmail;
  String? memberName;
  DateTime? memberBirthDay;
  String? memberMobile;
  String? memberNickname;
  String? memberMugShot;
  List<String>? breeding;
  List<String>? finding;
  List<String>? petManagement;
  List<String>? socialMedia;
  List<String>? socialMediaMessageBoard;

  Member({
    this.memberId,
    this.memberEmail,
    this.memberName,
    this.memberBirthDay,
    this.memberMobile,
    this.memberNickname,
    this.memberMugShot,
    this.breeding,
    this.finding,
    this.petManagement,
    this.socialMedia,
    this.socialMediaMessageBoard,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['Member_ID'],
      memberEmail: json['Member_Email'],
      memberName: json['Member_Name'],
      memberBirthDay: DateTime.parse(json['Member_BirthDay']),
      memberMobile: json['Member_Mobile'],
      memberNickname: json['Member_Nickname'],
      memberMugShot: json['Member_MugShot'],
      breeding: List<String>.from(json['Breeding'] ?? []),
      finding: List<String>.from(json['Finding'] ?? []),
      petManagement: List<String>.from(json['PetManagement'] ?? []),
      socialMedia: List<String>.from(json['SocialMedia'] ?? []),
      socialMediaMessageBoard:
          List<String>.from(json['SocialMediaMessageBoard'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Member_ID': memberId,
      'Member_Email': memberEmail,
      'Member_Name': memberName,
      'Member_BirthDay': memberBirthDay?.toIso8601String(),
      'Member_Mobile': memberMobile,
      'Member_Nickname': memberNickname,
      'Member_MugShot': memberMugShot,
      'Breeding': breeding,
      'Finding': finding,
      'PetManagement': petManagement,
      'SocialMedia': socialMedia,
      'SocialMediaMessageBoard': socialMediaMessageBoard,
    };
  }
}
