import 'package:flutter/material.dart';
import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/notification.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/model/social_media.dart';
import 'package:pet_app/model/social_media_message_board.dart';
import 'package:pet_app/services/breedings_service.dart';
import 'package:pet_app/services/findings_service.dart';
import 'package:pet_app/services/members_service.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/services/pets_service.dart';
import 'package:pet_app/services/social_media_message_board_service.dart';
import 'package:pet_app/services/social_medias_service.dart';
import 'package:pet_app/utils/inv_code_generator.dart';

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
    _member = await MembersService.getMemberByEmail(email ?? _memberEmail!);
    _petManagement.clear();
    _petManagement.addAll(_member!.petManagementList);
    getPetNotifications();
    notifyListeners();
  }

  void getPetNotifications() {
    _allNotifications.clear();
    for (var value in _petManagement) {
      var pet = value.pet;
      if (pet != null) {
        // _allNotifications.addAll(pet.adviceList);
        // _allNotifications.addAll(pet.drugList);
        // for (var vaccine in pet.vaccineList) {
        //   if (vaccine.vaccineNextDate != null) {
        //     _allNotifications.add(vaccine);
        //   }
        // }
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
              dateTime: vaccine.vaccineNextDate,
            ));
          }
        }
      }
    }

    // 按日期排列(遞增)
    // _allNotifications.sort((a, b) {
    //   DateTime? dateTimeA, dateTimeB;
    //   if (a is Advice) {
    //     dateTimeA = a.adviceDateTime;
    //   } else if (a is Drug) {
    //     dateTimeA = a.drugNextDate;
    //   } else if (a is Vaccine) {
    //     if (a.vaccineNextDate != null) {
    //       dateTimeA = a.vaccineNextDate!;
    //     }
    //   }

    //   if (b is Advice) {
    //     dateTimeB = b.adviceDateTime;
    //   } else if (b is Drug) {
    //     dateTimeB = b.drugNextDate;
    //   } else if (b is Vaccine) {
    //     if (b.vaccineNextDate != null) {
    //       dateTimeB = b.vaccineNextDate!;
    //     }
    //   }

    //   if (dateTimeA != null && dateTimeB != null) {
    //     return dateTimeA.compareTo(dateTimeB);
    //   } else {
    //     return 0;
    //   }
    // });
    // 按日期排列(遞增)
    allNotifications.sort((a, b) {
      if (a.dateTime != null && b.dateTime != null) {
        return a.dateTime!.compareTo(b.dateTime!);
      } else {
        return 0;
      }
    });

    // 列出列表
    // print(_allNotifications);
    // for (var element in allNotifications) {
    //   if (element is Advice) {
    //     print(element.adviceDateTime);
    //   } else if (element is Drug) {
    //     print(element.drugNextDate);
    //   } else if (element is Vaccine) {
    //     print(element.vaccineNextDate);
    //   }
    // }
  }

  Future<void> addPet(dynamic submitData, {int retryCount = 0}) async {
    const int maxRetries = 2;
    try {
      await PetsService.getPetByCode(submitData['Pet_InvCode']).then((_) async {
        // 如果 InvCdoe 已存在
        debugPrint('Code已存在');
        if (retryCount < maxRetries) {
          submitData['Pet_InvCode'] = generateInvCode();
          await addPet(submitData, retryCount: retryCount + 1);
        } else {
          throw ('新增寵物失敗，請再試一次。');
        }
      }).then((_) async {
        Pet pet = await PetsService.createPet(submitData);
        final petManagementData = {
          "PM_MemberID": _member?.memberId,
          "PM_PetID": pet.petId,
          "PM_Permissions": '1',
        };
        await PetManagementsService.createPetManagement(petManagementData);
        await updateMember();
      });

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editPet(int petId, dynamic data) async {
    await PetsService.updatePet(petId, data);
    updateMember();
    notifyListeners();
  }

  Future<void> deletePet(int pmId, int petId) async {
    await PetManagementsService.deletePetManagement(pmId);
    await PetsService.deletePet(petId);
    updateMember();
    notifyListeners();
  }

  Future<void> fetchAllPetBreedings() async {
    try {
      await BreedingsService.getBreedings().then((breedings) async {
        _allBreedingsList.clear();
        for (var breeding in breedings) {
          final pet = await PetsService.getPetById(breeding.breedingPetId);
          _allBreedingsList.add((breeding, pet));
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMyPetBreedings() async {
    try {
      await BreedingsService.getBreedingsByMemberId(_member!.memberId)
          .then((breedings) async {
        _myBreedingList.clear();
        for (var breeding in breedings) {
          final pet = await PetsService.getPetById(breeding.breedingPetId);
          _myBreedingList.add((breeding, pet));
        }
      });
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
    await FindingsService.getFindings().then((findings) async {
      _allMissingsList.clear();
      _allFoundsList.clear();
      for (var finding in findings) {
        if (finding.findingLostOrFound) {
          final pet = await PetsService.getPetById(finding.findingPetId!);
          _allMissingsList.add((finding, pet));
        } else {
          _allFoundsList.add(finding);
        }
      }
    });
    notifyListeners();
  }

  Future<void> fetchMyPetFindings() async {
    await FindingsService.getFindingsByMemberId(_member!.memberId)
        .then((findings) async {
      _myMissingsList.clear();
      _myFoundsList.clear();
      for (var finding in findings) {
        if (finding.findingLostOrFound) {
          final pet = await PetsService.getPetById(finding.findingPetId!);
          _myMissingsList.add((finding, pet));
        } else {
          _myFoundsList.add(finding);
        }
      }
    });
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
    List<(SocialMediaMessageBoard, Member)> tmpMessageBoards = [];
    Set<int> tmpMemberIds = {};
    Map<int, Member> tmpMembers = {};

    await SocialMediasService.getSocialMediaById(smId)
        .then((socialMedia) async {
      for (var messageBoard in socialMedia.messageBoards) {
        int memberId = messageBoard.mbMemberId;

        // 檢查 memberId 是否已經請求過，用以緩存 Member
        if (tmpMemberIds.contains(memberId)) {
          tmpMessageBoards.add((messageBoard, tmpMembers[memberId]!));
        } else {
          tmpMemberIds.add(memberId);
          await MembersService.getMemberById(memberId).then((member) {
            tmpMembers[memberId] = member;
            tmpMessageBoards.add((messageBoard, member));
          });
        }
      }
      _messageBoards.clear();
      _messageBoards.addAll(tmpMessageBoards);
    });
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
