import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/widgets/filled_text_field.dart';

class EditPetPage extends StatefulWidget {
  const EditPetPage({super.key});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  TextEditingController dateController = TextEditingController();
  DateTime _datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                  const FilledTextField(
                    labelText: '名稱',
                    hintText: 'Pudding',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '類別',
                    hintText: '狗',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '品種',
                    hintText: '馬爾濟思',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '年紀',
                    hintText: '5歲',
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    controller: dateController,
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
                                  dateController.text = DateFormat('yyyy/MM/dd')
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
                  const FilledTextField(
                    labelText: '體重',
                    hintText: '5公斤',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '性別',
                    hintText: '公',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '是否結紮',
                    hintText: '是',
                  ),
                  const SizedBox(height: 10),
                  const FilledTextField(
                    labelText: '血型',
                    hintText: 'DEA1(+)',
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
                onPressed: () {
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
