import 'dart:typed_data';

import 'package:pet_app/model/pet_management.dart';

class CommingSoonNotification {
  dynamic model;
  int id;
  String petName;
  Uint8List? petMugShot;
  PetManagement petManagement;
  String title;
  DateTime dateTime;

  CommingSoonNotification({
    required this.model,
    required this.id,
    required this.petName,
    this.petMugShot,
    required this.petManagement,
    required this.title,
    required this.dateTime,
  });
}
