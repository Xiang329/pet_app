import 'package:flutter/material.dart';
import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/models/member.dart';

class MemberProvider extends ChangeNotifier {
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
    _member = await ApiMethod().getMethod_Member(_memberEmail);
    _pets = _member?.pet;
    _isLoading = false;
    notifyListeners();
  }
}
