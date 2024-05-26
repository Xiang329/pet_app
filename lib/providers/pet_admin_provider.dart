import 'package:pet_app/models/pet_admin.dart';
import 'package:flutter/material.dart';

class PetAdminsProvider extends ChangeNotifier {
  final List<PetAdmin> _petAdmins = [
    PetAdmin("Hank", 1),
    PetAdmin("Jenny", 2),
    PetAdmin("Apple", 2),
    PetAdmin("Banana", 1),
  ];

  List<PetAdmin> get petAdmins => _petAdmins;

  void removePetAdmin(PetAdmin admin) {
    _petAdmins.remove(admin);
    notifyListeners();
  }

  void insertPetAdmin(int index, PetAdmin admin) {
    _petAdmins.insert(index, admin);
    notifyListeners();
  }
}
