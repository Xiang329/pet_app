class PetVariety {
  int pvId;
  int pcId;
  String pvVarietyName;

  PetVariety({
    required this.pvId,
    required this.pcId,
    required this.pvVarietyName,
  });

  factory PetVariety.fromJson(Map<String, dynamic> json) {
    return PetVariety(
      pvId: json['PV_ID'],
      pcId: json['PC_ID'],
      pvVarietyName: json['PV_VarietyName'].trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'PV_ID': pvId,
        'PC_ID': pcId,
        'PV_VarietyName': pvVarietyName,
      };
}
