class Animal {
  int animalId;
  String animalSubid;
  String animalAreaPkid;
  String animalShelterPkid;
  String animalPlace;
  String animalKind;
  String animalSex;
  String animalVariety;
  String animalBodytype;
  String animalColour;
  String animalAge;
  String animalSterilization;
  String animalFoundplace;
  String animalTitle;
  String animalStatus;
  String animalRemark;
  String animalCaption;
  String animalOpendate;
  String animalCloseddate;
  String animalUpdate;
  String animalCreatetime;
  String shelterName;
  String albumFile;
  String albumUpdate;
  String cDate;
  String shelterAddress;
  String shelterTel;

  Animal({
    required this.animalId,
    required this.animalSubid,
    required this.animalAreaPkid,
    required this.animalShelterPkid,
    required this.animalPlace,
    required this.animalKind,
    required this.animalVariety,
    required this.animalSex,
    required this.animalBodytype,
    required this.animalColour,
    required this.animalAge,
    required this.animalSterilization,
    required this.animalFoundplace,
    required this.animalTitle,
    required this.animalStatus,
    required this.animalRemark,
    required this.animalCaption,
    required this.animalOpendate,
    required this.animalCloseddate,
    required this.animalUpdate,
    required this.animalCreatetime,
    required this.shelterName,
    required this.albumFile,
    required this.albumUpdate,
    required this.cDate,
    required this.shelterAddress,
    required this.shelterTel,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    String trimString(dynamic value) {
      return value.toString().isNotEmpty ? value.toString().trim() : '- - -';
    }

    Map<String, String> sexMap = {'M': '公', 'F': '母', 'N': '未輸入'};

    return Animal(
      animalId: json['animal_id'],
      animalSubid: trimString(json['animal_subid']),
      animalAreaPkid: trimString(json['animal_area_pkid']),
      animalShelterPkid: trimString(json['animal_shelter_pkid']),
      animalPlace: trimString(json['animal_place']),
      animalKind: trimString(json['animal_kind']),
      animalVariety: trimString(json['animal_Variety']),
      animalSex: sexMap[trimString(json['animal_sex'])]!,
      animalBodytype: trimString(json['animal_bodytype']),
      animalColour: trimString(json['animal_colour']),
      animalAge: trimString(json['animal_age']),
      animalSterilization: trimString(json['animal_sterilization']),
      animalFoundplace: trimString(json['animal_foundplace']),
      animalTitle: trimString(json['animal_title']),
      animalStatus: trimString(json['animal_status']),
      animalRemark: trimString(json['animal_remark']),
      animalCaption: trimString(json['animal_caption']),
      animalOpendate: trimString(json['animal_opendate']),
      animalCloseddate: trimString(json['animal_closeddate']),
      animalUpdate: trimString(json['animal_update']),
      animalCreatetime: trimString(json['animal_createtime']),
      shelterName: trimString(json['shelter_name']),
      albumFile: trimString(json['album_file']),
      albumUpdate: trimString(json['album_update']),
      cDate: trimString(json['c_date']),
      shelterAddress: trimString(json['shelter_address']),
      shelterTel: trimString(json['shelter_tel']),
    );
  }

  @override
  String toString() {
    return 'Animal(animalId: $animalId, animalSubid: $animalSubid, animalAreaPkid: $animalAreaPkid, animalShelterPkid: $animalShelterPkid, animalPlace: $animalPlace, animalKind: $animalKind, animalSex: $animalSex, animalBodytype: $animalBodytype, animalColour: $animalColour, animalAge: $animalAge, animalSterilization: $animalSterilization, animalFoundplace: $animalFoundplace, animalTitle: $animalTitle, animalStatus: $animalStatus, animalRemark: $animalRemark, animalCaption: $animalCaption, animalOpendate: $animalOpendate, animalCloseddate: $animalCloseddate, animalUpdate: $animalUpdate, animalCreatetime: $animalCreatetime, shelterName: $shelterName, albumFile: $albumFile, albumUpdate: $albumUpdate, cDate: $cDate, shelterAddress: $shelterAddress, shelterTel: $shelterTel)';
  }
}
