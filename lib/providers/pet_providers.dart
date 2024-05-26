import 'package:pet_app/models/pet.dart';
import 'package:flutter/material.dart';

class PetsProvider extends ChangeNotifier {
  final List<Pet> _pets = [
    Pet("Dog1", 1, true),
    Pet("Dog2", 3, true),
    Pet("Dog3", 5, false),
    Pet("Dog4", 7, false),
    Pet("Dog5", 9, true),
    Pet("Dog6", 11, true),
    Pet("Dog7", 13, false),
    Pet("Dog8", 15, false),
    Pet("Dog9", 17, true),
    Pet("Dog10", 19, true),
  ];

  List<Pet> get pets => _pets;

  void removePet(Pet pet) {
    _pets.remove(pet);
    notifyListeners();
  }

  void insertPet(int index,Pet pet){
    _pets.insert(index, pet);
    notifyListeners();
  }
}
