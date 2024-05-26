import 'package:pet_app/models/comming_soon_notfy.dart';
import 'package:flutter/material.dart';

class CommonSoonNotifyProvider extends ChangeNotifier {
  final List<CommingSoonNotify> _notifys = [
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
    CommingSoonNotify("打針", "4/18 15:00", "Pudding"),
  ];

  List<CommingSoonNotify> get notifys => _notifys;

  void removePet(CommingSoonNotify pet) {
    _notifys.remove(pet);
    notifyListeners();
  }

  void insertPet(int index, CommingSoonNotify pet) {
    _notifys.insert(index, pet);
    notifyListeners();
  }
}
