import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/area_data.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/breeding/widgets/select_pet_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddMissingPage extends StatefulWidget {
  const AddMissingPage({super.key});

  @override
  State<AddMissingPage> createState() => _AddMissingPageState();
}

class _AddMissingPageState extends State<AddMissingPage> {
  @override
  Widget build(BuildContext context) {
    return const AddMissingSetp1();
  }
}

class AddMissingSetp1 extends StatefulWidget {
  const AddMissingSetp1({super.key});

  @override
  State<AddMissingSetp1> createState() => _AddMissingSetp1State();
}

class _AddMissingSetp1State extends State<AddMissingSetp1> {
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
                            builder: (context) => AddMissingSetp2(
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

class AddMissingSetp2 extends StatefulWidget {
  final Pet pet;
  const AddMissingSetp2({super.key, required this.pet});

  @override
  State<AddMissingSetp2> createState() => _AddMissingSetp2State();
}

class _AddMissingSetp2State extends State<AddMissingSetp2> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController missingDateController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final petClassesList = PetClassesService.petClassesMap.values.toList();
  final petVarietiesList = PetVarietiesService.petVarietyMap.values
      .map((petVariety) => petVariety.pvVarietyName)
      .toList();
  DateTime _datetime = DateTime.now();

  List<String> petGender = [
    '男',
    '女',
  ];

  String? selectedPetClass;
  String? selectedPetVariety;
  String? selectedPetSex;
  String? selectedCitys;
  String? selectedDistrict;

  @override
  void initState() {
    petNameController.text = widget.pet.petName;
    selectedPetClass = petClassesList.firstWhere(
        (value) => value.contains(widget.pet.className),
        orElse: () => 'null');
    selectedPetVariety = petVarietiesList.firstWhere(
        (value) => value.contains(widget.pet.varietyName),
        orElse: () => 'null');
    selectedPetSex = petGender
        .firstWhere((value) => value.contains(widget.pet.petSex ? '男' : '女'));
    super.initState();
  }

  Future submit() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final fullAddress =
        '$selectedCitys$selectedDistrict${placeController.text}';
    final findingData = {
      'Finding_MemberID': appProvider.memberId,
      'Finding_LostOrFound': true,
      'Finding_Content': contentController.text,
      'Finding_DataTime': _datetime.toIso8601String(),
      'Finding_Place': fullAddress,
      'Finding_Image': null,
      'Finding_PetID': widget.pet.petId,
      "Finding_Mobile": mobileController.text,
    };
    debugPrint(findingData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await appProvider.addPetFinding(findingData);
        if (!mounted) return;
        Navigator.of(context).pop();
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
        title: const Text("新增遺失寵物"),
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
                          : MemoryImage(widget.pet.petMugShot),
                    ),
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
                controller: contentController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '其他描述',
                ),
                labelText: '其他描述',
                maxLines: 4,
                alignLabelWithHint: true,
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                readOnly: true,
                controller: missingDateController,
                validator: (value) => Validators.dateTimeValidator(value!),
                labelText: "遺失日期",
                onTap: () {
                  showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        color: UiColor.theme1Color,
                        child: CupertinoDatePicker(
                          initialDateTime: _datetime,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (datetime) {
                            _datetime = datetime;
                            missingDateController.text = datetime.formatDate();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: DropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '遺失縣市',
                      ),
                      title: '遺失縣市',
                      items: areaData.keys.toList(),
                      value: selectedCitys,
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = null;
                          selectedCitys = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: DropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '遺失區域',
                      ),
                      title: '遺失區域',
                      items: areaData[selectedCitys] ?? [],
                      value: selectedDistrict,
                      onChanged: (String? value) {
                        setState(() {
                          selectedDistrict = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: placeController,
                validator: (value) => Validators.stringValidator(
                  value!,
                  errorMessage: '遺失地點',
                ),
                labelText: "遺失地點",
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: mobileController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '聯絡方式',
                  onlyInt: true,
                ),
                labelText: '聯絡方式',
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
