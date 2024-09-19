import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:provider/provider.dart';

class EditMyBreedingPage extends StatefulWidget {
  final Breeding breeding;
  final Pet pet;
  const EditMyBreedingPage({
    super.key,
    required this.breeding,
    required this.pet,
  });

  @override
  State<EditMyBreedingPage> createState() => _EditMyBreedingPageState();
}

class _EditMyBreedingPageState extends State<EditMyBreedingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController varietyNameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  Future submit() async {
    final breedingData = {
      "Breeding_ID": widget.breeding.breedingId,
      "Breeding_MemberID": widget.breeding.breedingMemberId,
      "Breeding_PetID": widget.breeding.breedingPetId,
      "Breeding_Content": contentController.text,
      "Breeding_Comment": widget.breeding.breedingComment,
      "Breeding_Mobile": mobileController.text,
    };
    debugPrint(breedingData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await Provider.of<AppProvider>(context, listen: false)
            .editPetBreeding(widget.breeding.breedingId, breedingData);
        if (!mounted) return;
        Navigator.of(context).pop(true);
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
    petNameController.text = widget.pet.petName;
    ageController.text = widget.pet.petAge.toString();
    classNameController.text = widget.pet.className;
    varietyNameController.text = widget.pet.varietyName;
    sexController.text = widget.pet.petSex ? "男" : "女";
    contentController.text = widget.breeding.breedingContent;
    mobileController.text = widget.breeding.breedingMobile == null
        ? ''
        : widget.breeding.breedingMobile!;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("編輯配種資料"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 375,
                  maxHeight: 375,
                ),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: widget.pet.petMugShot.isEmpty
                          ? Image.asset(AssetsImages.petAvatorPng)
                          : Image.memory(widget.pet.petMugShot),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: petNameController,
                      labelText: '寵物名稱',
                      topLeftRadius: 8,
                      topRightRadius: 8,
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: classNameController,
                      labelText: '類別',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: varietyNameController,
                      labelText: '品種',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: sexController,
                      labelText: '性別',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: ageController,
                      labelText: '年紀',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: contentController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '配種內容',
                      ),
                      maxLines: 4,
                      labelText: '配種內容',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: mobileController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '聯絡資訊',
                        onlyInt: true,
                      ),
                      maxLines: 4,
                      labelText: '聯絡資訊',
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 42,
                child: CustomButton(asyncOnPressed: submit, buttonText: '確定'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
