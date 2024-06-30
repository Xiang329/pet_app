class Member {
  int memberId;
  String memberEmail;
  String memberName;
  DateTime memberBirthDay;
  String memberMobile;
  String memberNickname;
  String? memberMugShot;
  // List<String> breeding;
  // List<String> finding;
  List<Pet> pet;
  // List<String> petManagement;
  // List<String> socialMedia;
  // List<String> socialMediaMessageBoard;

  Member({
    required this.memberId,
    required this.memberEmail,
    required this.memberName,
    required this.memberBirthDay,
    required this.memberMobile,
    required this.memberNickname,
    this.memberMugShot,
    // required this.breeding,
    // required this.finding,
    required this.pet,
    // required this.petManagement,
    // required this.socialMedia,
    // required this.socialMediaMessageBoard,
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
      // breeding: List<String>.from(json['Breeding'] ?? []),
      // finding: List<String>.from(json['Finding'] ?? []),
      pet: List<Pet>.from(
          (json['Pet'] as List).map((x) => Pet.fromJson(x)) ?? []),
      // petManagement: List<String>.from(json['PetManagement'] ?? []),
      // socialMedia: List<String>.from(json['SocialMedia'] ?? []),
      // socialMediaMessageBoard:
      //     List<String>.from(json['SocialMediaMessageBoard'] ?? []),
    );
  }
}

class Pet {
  final int id;
  final String icid;
  final String name;
  final DateTime birthDay;
  final int age;
  final bool sex;
  final int variety;
  final double weight;
  final bool ligation;
  final String blood;
  final String? mugShot;
  final String invCode;
  final String varietyName;
  final String className;
  final List<dynamic> petManagement;
  final int pmid;

  Pet({
    required this.id,
    required this.icid,
    required this.name,
    required this.birthDay,
    required this.age,
    required this.sex,
    required this.variety,
    required this.weight,
    required this.ligation,
    required this.blood,
    this.mugShot,
    required this.invCode,
    required this.varietyName,
    required this.className,
    required this.petManagement,
    required this.pmid,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['Pet_ID'],
      icid: json['Pet_ICID'],
      name: json['Pet_Name'],
      birthDay: DateTime.parse(json['Pet_BirthDay']),
      age: json['Pet_Age'],
      sex: json['Pet_Sex'],
      variety: json['Pet_Variety'],
      weight: json['Pet_Weight'],
      ligation: json['Pet_Ligation'],
      blood: json['Pet_Blood'],
      mugShot: json['Pet_MugShot'],
      invCode: json['Pet_InvCode'],
      varietyName: json['PetVariety']['PV_VarietyName'],
      className: json['PetVariety']['PetClass']['PC_ClassName'],
      petManagement: List.from((json['PetManagement'] as List).map((x) => x)),
      pmid: List.from((json['PetManagement'] as List).map((x) => x))
          .first['PM_ID'],
    );
  }

  @override
  String toString() {
    return 'Pet{'
        'id: $id, '
        'icid: $icid, '
        'name: $name, '
        'birthDay: $birthDay, '
        'age: $age, '
        'sex: $sex, '
        'variety: $variety, '
        'weight: $weight, '
        'ligation: $ligation, '
        'blood: $blood, '
        'mugShot: $mugShot, '
        'invCode: $invCode, '
        'varietyName: $varietyName, '
        'className: $className, '
        'petManagement: $petManagement'
        'pmid: $pmid'
        '}';
  }
}
