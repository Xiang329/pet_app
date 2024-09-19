import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/breeding/widgets/select_pet_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddBreedingPage extends StatefulWidget {
  const AddBreedingPage({super.key});

  @override
  State<AddBreedingPage> createState() => _AddBreedingPageState();
}

class _AddBreedingPageState extends State<AddBreedingPage> {
  @override
  Widget build(BuildContext context) {
    return const AddBreedingSetp1();
  }
}

class AddBreedingSetp1 extends StatefulWidget {
  const AddBreedingSetp1({super.key});

  @override
  State<AddBreedingSetp1> createState() => _AddBreedingSetp1State();
}

class _AddBreedingSetp1State extends State<AddBreedingSetp1> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final petManagement = Provider.of<AppProvider>(context).petManagement;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("請選擇寵物"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: petManagement.length,
              itemBuilder: (context, index) {
                return SelectPetItem(
                  pet: petManagement[index].pet!,
                  petIndex: index,
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 0),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 42,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: UiColor.theme2Color),
                onPressed: selectedIndex < 0
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AddBreedingSetp2(
                              pet: petManagement[selectedIndex].pet!,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddBreedingSetp2 extends StatefulWidget {
  final Pet pet;
  const AddBreedingSetp2({super.key, required this.pet});

  @override
  State<AddBreedingSetp2> createState() => _AddBreedingSetp2State();
}

class _AddBreedingSetp2State extends State<AddBreedingSetp2> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final petClassesList = PetClassesService.petClassesMap.values.toList();
  final petVarietiesList = PetVarietiesService.petVarietyMap.values
      .map((petVariety) => petVariety.pvVarietyName)
      .toList();

  List<String> petGender = [
    '男',
    '女',
  ];

  String? selectedPetClass;
  String? selectedPetVariety;
  String? selectedPetSex;

  @override
  void initState() {
    super.initState();
    petNameController.text = widget.pet.petName;
    ageController.text = widget.pet.petAge.toString();
    selectedPetClass = petClassesList
        .firstWhereOrNull((value) => value.contains(widget.pet.className));
    selectedPetVariety = petVarietiesList
        .firstWhereOrNull((value) => value.contains(widget.pet.varietyName));
    selectedPetSex = petGender.firstWhereOrNull(
        (value) => value.contains(widget.pet.petSex ? '男' : '女'));
  }

  Future submit() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final petBreedingData = {
      'Breeding_MemberID': appProvider.memberId,
      'Breeding_Content': contentController.text,
      'Breeding_Comment': null,
      'Breeding_PetID': widget.pet.petId,
      'Breeding_Mobile': mobileController.text,
    };
    debugPrint(petBreedingData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await appProvider.addPetBreeding(petBreedingData);
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('錯誤'),
            content: Text(e.toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("新增寵物資料"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                    maxWidth: 320,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: UiColor.navigationBarColor,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: widget.pet.petMugShot.isEmpty
                            ? const AssetImage(AssetsImages.petPhotoPng)
                            : MemoryImage(widget.pet.petMugShot)),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                readOnly: true,
                controller: petNameController,
                labelText: "寵物名稱",
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: '類別',
                items: petClassesList,
                value: selectedPetClass,
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: '品種',
                items: petVarietiesList,
                value: selectedPetVariety,
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: '性別',
                items: petGender,
                value: selectedPetSex,
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                readOnly: true,
                controller: ageController,
                labelText: "年紀",
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: contentController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '配種內容',
                ),
                labelText: '配種內容',
                maxLines: 4,
                alignLabelWithHint: true,
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: mobileController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '聯絡資訊',
                  onlyInt: true,
                ),
                labelText: '聯絡資訊',
                maxLines: 4,
                alignLabelWithHint: true,
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: CustomButton(asyncOnPressed: submit, buttonText: '發布'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
