import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/models/member.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;
  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController varietyNameController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ligationController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  DateTime _datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    petNameController.text = widget.pet.name;
    ageController.text = widget.pet.age.toString();
    birthDayController.text = DateFormat('yyyy/MM/dd').format(widget.pet.birthDay);
    _datetime = widget.pet.birthDay;
    classNameController.text = widget.pet.className;
    varietyNameController.text = widget.pet.varietyName;
    sexController.text = widget.pet.sex ? "男" : "女";
    weightController.text = widget.pet.weight.toString();
    ligationController.text = widget.pet.ligation ? "是" : "否";
    bloodController.text = widget.pet.blood;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("寵物檔案"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 56,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: AssetImage(AssetsImages.catJpg),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: UiColor.theme2_color,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              color: UiColor.theme1_color,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledTextField(
                    labelText: '名稱',
                    hintText: 'Pudding',
                    controller: petNameController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '類別',
                    hintText: '狗',
                    controller: classNameController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '品種',
                    hintText: '馬爾濟思',
                    controller: varietyNameController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '年紀',
                    hintText: '5歲',
                    controller: ageController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    readOnly: true,
                    controller: birthDayController,
                    labelText: '生日',
                    onTap: () {
                      showModalBottomSheet(
                        clipBehavior: Clip.antiAlias,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            color: UiColor.theme1_color,
                            child: CupertinoDatePicker(
                              initialDateTime: _datetime,
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (datetime) {
                                setState(() {
                                  _datetime = datetime;
                                  birthDayController.text = DateFormat('yyyy/MM/dd')
                                      .format(datetime)
                                      .toString();
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '體重',
                    hintText: '5公斤',
                    controller: weightController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '性別',
                    hintText: '公',
                    controller: sexController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '是否結紮',
                    hintText: '是',
                    controller: ligationController,
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    labelText: '血型',
                    hintText: 'DEA1(+)',
                    controller: bloodController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 42,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: UiColor.theme2_color),
                child: const Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final petData = {
                    "Pet_ID": widget.pet.id,
                    "Pet_ICID": widget.pet.icid,
                    "Pet_Name": petNameController.text,
                    "Pet_BirthDay": birthDayController.text,
                    "Pet_Age": ageController.text,
                    "Pet_Sex": widget.pet.sex,
                    "Pet_Variety": widget.pet.variety,
                    "Pet_Weight": weightController.text,
                    "Pet_Ligation": widget.pet.ligation,
                    "Pet_Blood": bloodController.text,
                    "Pet_MugShot": widget.pet.mugShot,
                    "Pet_InvCode": widget.pet.invCode,
                  };
                  print(petData);
                  await ApiMethod().putMethod('Pets', widget.pet.id, petData);
                  await Provider.of<MemberProvider>(context, listen: false)
                      .updateMember();
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
