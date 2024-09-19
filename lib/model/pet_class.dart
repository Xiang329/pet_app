class PetClass {
  int pcId;
  String pcClassName;

  PetClass({
    required this.pcId,
    required this.pcClassName,
  });

  factory PetClass.fromJson(Map<String, dynamic> json) {
    return PetClass(
      pcId: json['PC_ID'],
      pcClassName: json['PC_ClassName'].trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'PC_ID': pcId,
        'PC_ClassName': pcClassName,
      };
}
