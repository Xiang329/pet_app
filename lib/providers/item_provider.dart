import 'package:pet_app/models/item.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier {
  final List<Item> _notifyItem = [
    Item("Notify_Title1", "SubTitle1"),
    Item("Notify_Title2", "SubTitle2"),
    Item("Notify_Title3", "SubTitle3"),
    Item("Notify_Title4", "SubTitle4"),
    Item("Notify_Title5", "SubTitle5"),
    Item("Notify_Title6", "SubTitle6"),
    Item("Notify_Title7", "SubTitle7"),
    Item("Notify_Title8", "SubTitle8"),
  ];
  final List<Item> _vaccineItem = [
    Item("Vaccine_Title1", "SubTitle1"),
    Item("Vaccine_Title2", "SubTitle2"),
    Item("Vaccine_Title3", "SubTitle3"),
    Item("Vaccine_Title4", "SubTitle4"),
    Item("Vaccine_Title5", "SubTitle5"),
    Item("Vaccine_Title6", "SubTitle6"),
    Item("Vaccine_Title7", "SubTitle7"),
    Item("Vaccine_Title8", "SubTitle8"),
  ];

  final List<Item> _drugItem = [
    Item("Drug_Title1", "SubTitle1"),
    Item("Drug_Title2", "SubTitle2"),
    Item("Drug_Title3", "SubTitle3"),
    Item("Drug_Title4", "SubTitle4"),
    Item("Drug_Title5", "SubTitle5"),
    Item("Drug_Title6", "SubTitle6"),
    Item("Drug_Title7", "SubTitle7"),
    Item("Drug_Title8", "SubTitle8"),
  ];

  final List<Item> _medicalItem = [
    Item("Medical_Title1", "SubTitle1"),
    Item("Medical_Title2", "SubTitle2"),
    Item("Medical_Title3", "SubTitle3"),
    Item("Medical_Title4", "SubTitle4"),
    Item("Medical_Title5", "SubTitle5"),
    Item("Medical_Title6", "SubTitle6"),
    Item("Medical_Title7", "SubTitle7"),
    Item("Medical_Title8", "SubTitle8"),
  ];

  final List<Item> _dietItem = [
    Item("Diet_Title1", "SubTitle1"),
    Item("Diet_Title2", "SubTitle2"),
    Item("Diet_Title3", "SubTitle3"),
    Item("Diet_Title4", "SubTitle4"),
    Item("Diet_Title5", "SubTitle5"),
    Item("Diet_Title6", "SubTitle6"),
    Item("Diet_Title7", "SubTitle7"),
    Item("Diet_Title8", "SubTitle8"),
  ];

  final List<Item> _excretionItem = [
    Item("Excretion_Title1", "SubTitle1"),
    Item("Excretion_Title2", "SubTitle2"),
    Item("Excretion_Title3", "SubTitle3"),
    Item("Excretion_Title4", "SubTitle4"),
    Item("Excretion_Title5", "SubTitle5"),
    Item("Excretion_Title6", "SubTitle6"),
    Item("Excretion_Title7", "SubTitle7"),
    Item("Excretion_Title8", "SubTitle8"),
  ];

  List<Item> get notifyItem => _notifyItem;
  List<Item> get vaccineItem => _vaccineItem;
  List<Item> get drugItem => _drugItem;
  List<Item> get medicalItem => _medicalItem;
  List<Item> get dietItem => _dietItem;
  List<Item> get excretionItem => _excretionItem;

  void removeItem(List<Item> itemList, Item item) {
    itemList.remove(item);
    notifyListeners();
  }

  void insertItem(int index, List<Item> itemList, Item item) {
    itemList.insert(index, item);
    notifyListeners();
  }
}
