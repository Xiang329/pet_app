import 'package:flutter/material.dart';
import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/notification.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/model/social_media.dart';
import 'package:pet_app/model/social_media_message_board.dart';
import 'package:pet_app/services/advices_serivce.dart';
import 'package:pet_app/services/breedings_service.dart';
import 'package:pet_app/services/diets_serivce.dart';
import 'package:pet_app/services/durgs_serivce.dart';
import 'package:pet_app/services/excretions_serivce.dart';
import 'package:pet_app/services/findings_service.dart';
import 'package:pet_app/services/medicals_service.dart';
import 'package:pet_app/services/members_service.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/services/pets_service.dart';
import 'package:pet_app/services/social_media_message_board_service.dart';
import 'package:pet_app/services/social_medias_service.dart';
import 'package:pet_app/services/vaccines_serivce.dart';

class AppProvider extends ChangeNotifier {
  String? _memberEmail;
  Member? _member;
  final List<PetManagement> _petManagement = [];
  final List<(Breeding, Pet)> _myBreedingList = [];
  final List<(Finding, Pet)> _myMissingsList = [];
  final List<Finding> _myFoundsList = [];
  final List<SocialMedia> _mySocialMediasList = [];
  final List<(Breeding, Pet)> _allBreedingsList = [];
  final List<(Finding, Pet)> _allMissingsList = [];
  final List<Finding> _allFoundsList = [];
  final List<SocialMedia> _allSocialMediasList = [];
  final List<(SocialMediaMessageBoard, Member)> _messageBoards = [];
  final List<CommingSoonNotification> _allNotifications = [];

  Member? get member => _member;
  String? get memberEmail => _memberEmail;
  int? get memberId => _member?.memberId;
  List<PetManagement> get petManagement => _petManagement;
  List<(Breeding, Pet)> get myBreedingList => _myBreedingList;
  List<(Finding, Pet)> get myMissingsList => _myMissingsList;
  List<Finding> get myFoundsList => _myFoundsList;
  List<SocialMedia> get mySocialMediasList => _mySocialMediasList;
  List<(Breeding, Pet)> get allBreedingsList => _allBreedingsList;
  List<(Finding, Pet)> get allMissingsList => _allMissingsList;
  List<Finding> get allFoundsList => _allFoundsList;
  List<SocialMedia> get allSocialMediasList => _allSocialMediasList;
  List<(SocialMediaMessageBoard, Member)> get messageBorders => _messageBoards;
  List<CommingSoonNotification> get allNotifications => _allNotifications;

  void setEamil(String email) {
    if (_memberEmail == email) return;
    debugPrint('SetEamil:$email');
    _memberEmail = email;
  }

  void initialize() {
    _member = null;
    _petManagement.clear();
    _myBreedingList.clear();
    _myMissingsList.clear();
    _myFoundsList.clear();
    _mySocialMediasList.clear();
    _allBreedingsList.clear();
    _allMissingsList.clear();
    _allFoundsList.clear();
    _allSocialMediasList.clear();
    _messageBoards.clear();
    _allNotifications.clear();
  }

  Future<void> updateMember({String? email}) async {
    try {
      _member = await MembersService.getMemberByEmail(email ?? _memberEmail!);
      _petManagement.clear();
      _petManagement.addAll(_member!.petManagementList);
      getPetNotifications();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void getPetNotifications() {
    _allNotifications.clear();
    for (var value in _petManagement) {
      final pet = value.pet;
      if (pet != null) {
        for (var advice in pet.adviceList) {
          _allNotifications.add(CommingSoonNotification(
            model: advice,
            id: advice.adviceId,
            petName: pet.petName,
            petMugShot: pet.petMugShot,
            petManagement: value,
            title: advice.adviceTitle,
            dateTime: advice.adviceDateTime,
          ));
        }
        for (var drug in pet.drugList) {
          _allNotifications.add(CommingSoonNotification(
            model: drug,
            id: drug.drugId,
            petName: pet.petName,
            petMugShot: pet.petMugShot,
            petManagement: value,
            title: drug.drugName,
            dateTime: drug.drugNextDate,
          ));
        }
        for (var vaccine in pet.vaccineList) {
          if (vaccine.vaccineNextDate != null) {
            _allNotifications.add(CommingSoonNotification(
              model: vaccine,
              id: vaccine.vaccineId,
              petName: pet.petName,
              petMugShot: pet.petMugShot,
              petManagement: value,
              title: vaccine.vaccineName,
              dateTime: vaccine.vaccineNextDate!,
            ));
          }
        }
      }
    }
    // 按日期排列(遞增)
    allNotifications.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // 移除七天外日期
    final DateTime now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenDaysLater = todayStart.add(const Duration(days: 7));
    allNotifications.removeWhere((notification) {
      DateTime notificationDate = notification.dateTime;
      return notificationDate.isBefore(todayStart) ||
          notificationDate.isAfter(sevenDaysLater);
    });
  }

  Future<void> addPet(dynamic submitData) async {
    Pet? pet;
    try {
      try {
        await PetsService.getPetByCode(submitData['Pet_InvCode']).then((p) {
          pet = p;
          throw ('新增寵物失敗，請再試一次。');
        });
      } catch (e) {
        if (e == '新增寵物失敗，請再試一次。') rethrow;
      }
      if (pet == null) {
        await PetsService.createPet(submitData).then((p) async {
          final petManagementData = {
            "PM_MemberID": _member?.memberId,
            "PM_PetID": p.petId,
            "PM_Permissions": '1',
          };
          await PetManagementsService.createPetManagement(petManagementData);
          await updateMember();
          notifyListeners();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editPet(int petId, dynamic data) async {
    await PetsService.updatePet(petId, data);
    await updateMember();
    notifyListeners();
  }

  Future<void> deletePet(int pmId, int petId, String pmPermissions) async {
    try {
      if (pmPermissions == '1') {
        final pet = await PetsService.getPetById(petId);

        final List<Future> futures = [];
        futures.addAll(pet.adviceList
            .map((advice) => AdvicesService.deleteAdvice(advice.adviceId)));
        futures.addAll(
            pet.dietList.map((diet) => DietsService.deleteDiet(diet.dietId)));
        futures.addAll(
            pet.drugList.map((drug) => DrugsService.deleteDrug(drug.drugId)));
        futures.addAll(pet.medicalList.map(
            (medical) => MedicalsService.deleteMedical(medical.medicalId)));
        futures.addAll(pet.vaccineList.map(
            (vaccine) => VaccinesService.deleteVaccine(vaccine.vaccineId)));
        futures.addAll(pet.excretionList.map((excretion) =>
            ExcretionsService.deleteExcretion(excretion.excretionId)));
        futures.addAll(pet.petManagementList
            .map((pm) => PetManagementsService.deletePetManagement(pm.pmId)));

        await Future.wait(futures);
        await PetsService.deletePet(petId);
      } else {
        await PetManagementsService.deletePetManagement(pmId);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateMember();
      notifyListeners();
    }
  }

  Future<void> fetchAllPetBreedings() async {
    try {
      final breedings = await BreedingsService.getBreedings();

      // 建立非同步請求列表
      final futures = breedings.map((breeding) async {
        final pet = await PetsService.getPetById(breeding.breedingPetId);
        return (breeding, pet);
      }).toList();

      _allBreedingsList.clear();
      _allBreedingsList.addAll(await Future.wait(futures));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMyPetBreedings() async {
    try {
      final breedings =
          await BreedingsService.getBreedingsByMemberId(_member!.memberId);

      // 建立非同步請求列表
      final futures = breedings.map((breeding) async {
        final pet = await PetsService.getPetById(breeding.breedingPetId);
        return (breeding, pet);
      });
      _myBreedingList.clear();
      _myBreedingList.addAll(await Future.wait(futures));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPetBreeding(dynamic data) async {
    try {
      await BreedingsService.createBreeding(data);
      await fetchAllPetBreedings();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editPetBreeding(int id, dynamic data) async {
    try {
      await BreedingsService.updateBreeding(id, data);
      await fetchMyPetBreedings();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePetBreeding(int id) async {
    try {
      await BreedingsService.deleteBreeding(id);
      await fetchAllPetBreedings();
      await fetchMyPetBreedings();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAllPetFindings() async {
    final findings = await FindingsService.getFindings();

    _allMissingsList.clear();
    _allFoundsList.clear();

    final futures = findings.map((finding) async {
      if (finding.findingLostOrFound) {
        final pet = await PetsService.getPetById(finding.findingPetId!);
        return (finding, pet);
      } else {
        _allFoundsList.add(finding);
        return null;
      }
    });

    final results = await Future.wait(futures);
    _allMissingsList.addAll(results.whereType<(Finding, Pet)>());
    notifyListeners();
  }

  Future<void> fetchMyPetFindings() async {
    final findings =
        await FindingsService.getFindingsByMemberId(_member!.memberId);

    _myMissingsList.clear();
    _myFoundsList.clear();

    final futures = findings.map((finding) async {
      if (finding.findingLostOrFound) {
        final pet = await PetsService.getPetById(finding.findingPetId!);
        return (finding, pet);
      } else {
        _myFoundsList.add(finding);
        return null;
      }
    });

    final result = await Future.wait(futures);
    _myMissingsList.addAll(result.whereType<(Finding, Pet)>());
    notifyListeners();
  }

  Future<void> addPetFinding(dynamic data) async {
    await FindingsService.createFinding(data);
    await fetchAllPetFindings();
    notifyListeners();
  }

  Future<void> editPetFinding(int id, dynamic data) async {
    await FindingsService.updateFinding(id, data);
    await fetchAllPetFindings();
    await fetchMyPetFindings();
    notifyListeners();
  }

  Future<void> deletePetFinding(int id) async {
    await FindingsService.deleteFinding(id);
    await fetchAllPetFindings();
    await fetchMyPetFindings();
    notifyListeners();
  }

  Future<void> fetchAllSocialMedias() async {
    final List<SocialMedia> socialMediasList =
        await SocialMediasService.getSocialMedias();
    _allSocialMediasList.clear();
    _allSocialMediasList.addAll(socialMediasList.reversed.toList());
    notifyListeners();
  }

  Future<void> fetchMySocialMedias() async {
    final List<SocialMedia> socialMediasList =
        await SocialMediasService.getSocialMediasByMemberId(_member!.memberId);
    _mySocialMediasList.clear();
    _mySocialMediasList.addAll(socialMediasList.reversed.toList());
    notifyListeners();
  }

  Future<void> addSocialMedia(dynamic data) async {
    await SocialMediasService.createSocialMedia(data).then((_) async {
      await fetchAllSocialMedias();
    });
    notifyListeners();
  }

  Future<void> editSocialMedia(int id, dynamic data) async {
    await SocialMediasService.updateSocialMedia(id, data).then((_) async {
      await fetchMySocialMedias();
      fetchAllSocialMedias();
    });
    notifyListeners();
  }

  Future<void> deleteSocialMedia(int id) async {
    await SocialMediasService.deleteSocialMedia(id).then((_) async {
      await fetchMySocialMedias();
      fetchAllSocialMedias();
    });
    notifyListeners();
  }

  Future<void> fetchCurrentMessageBoards(int smId) async {
    final socialMedia = await SocialMediasService.getSocialMediaById(smId);

    final futures = socialMedia.messageBoards.map((messageBoard) async {
      int memberId = messageBoard.mbMemberId;
      final member = await MembersService.getMemberById(memberId);
      return (messageBoard, member);
    }).toList();

    _messageBoards.clear();
    _messageBoards.addAll(await Future.wait(futures));
    notifyListeners();
  }

  Future<void> addMessageBoard(int smId, dynamic data) async {
    await SocialMediaMessageBoardsService.createSocialMediaMessage(data)
        .then((_) {
      fetchCurrentMessageBoards(smId);
    });
    notifyListeners();
  }

  Future<void> editMessageBoard(int smId, int mbId, dynamic data) async {
    await SocialMediaMessageBoardsService.updateSocialMediaMessage(mbId, data)
        .then((_) {
      fetchCurrentMessageBoards(smId);
    });
    notifyListeners();
  }

  Future<void> deleteMessageBoard(int smId, int mbId) async {
    await SocialMediaMessageBoardsService.deleteSocialMediaMessage(mbId)
        .then((_) {
      fetchCurrentMessageBoards(smId);
    });
    notifyListeners();
  }
}
