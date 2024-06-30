import 'package:flutter/material.dart';
import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/models/member.dart';

class MemberProvider extends ChangeNotifier {
  final _service = ApiMethod();
  String? _memberEmail;
  Member? _member;
  List<Pet>? _pets = [];
  bool _isLoading = false;

  String? get memberEmail => _memberEmail;
  int? get memberID => _member?.memberId;
  List<Pet>? get pets => _pets;
  Member? get member => _member;
  bool get isLoading => _isLoading;

  setEamil(String email) {
    _memberEmail = email;
  }

  Future<void> updateMember() async {
    _isLoading = true;
    _member = await _service.getMethod_Member(_memberEmail);
    _pets = _member?.pet;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPet(dynamic petData) async {
    _isLoading = true;
    dynamic response = await _service.postMethod('Pets', petData);
    final petManagementData = {
      "PM_MemberID": _member?.memberId,
      "PM_PetID": response['Pet_ID'],
      "PM_Permissions": true
    };
    await _service.postMethod('PetManagements', petManagementData);
    await updateMember();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deletePet(int pmid, int petid) async {
    _isLoading = true;
    await _service.deleteMethod('PetManagements', pmid);
    await _service.deleteMethod('Pets', petid);
    await updateMember();
    _isLoading = false;
    notifyListeners();
  }
}
