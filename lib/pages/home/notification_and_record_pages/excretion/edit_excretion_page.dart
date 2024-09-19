import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/excretion.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/excretions_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/add_picture.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:provider/provider.dart';

class EditExcretionPage extends StatefulWidget {
  final Excretion excretion;
  const EditExcretionPage({super.key, required this.excretion});

  @override
  State<EditExcretionPage> createState() => _EditExcretionPageState();
}

class _EditExcretionPageState extends State<EditExcretionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController situationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime _time = DateTime.now();
  Uint8List? picture;

  @override
  void initState() {
    super.initState();
    situationController.text = widget.excretion.excretionSituation!;
    dateController.text = widget.excretion.excretionDateTime.formatDate();
    timeController.text = widget.excretion.excretionDateTime.formatTime();
    _date = widget.excretion.excretionDateTime;
    _time = widget.excretion.excretionDateTime;
    picture = widget.excretion.excretionPicture.isEmpty
        ? null
        : widget.excretion.excretionPicture;
  }

  Future submit() async {
    DateTime dateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    final excretionData = {
      'Excretion_ID': widget.excretion.excretionId,
      'Excretion_PetID': widget.excretion.excretionPetId,
      'Excretion_DateTime': dateTime.toIso8601String(),
      'Excretion_Situation': situationController.text,
      'Excretion_Picture': picture,
    };
    // debugPrint(excretionData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await ExcretionsService.updateExcretion(
                widget.excretion.excretionId, excretionData)
            .then((_) async {
          if (!mounted) return;
          await Provider.of<AppProvider>(context, listen: false).updateMember();
        });
        if (!mounted) return;
        if (_dialogKey.currentContext != null) {
          Navigator.of(context, rootNavigator: true)
            ..pop()
            ..pop();
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            key: _dialogKey,
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
        backgroundColor: UiColor.theme1Color,
        title: const Text("排泄紀錄"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                        color: UiColor.theme1Color,
                        shadowColor: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledLeftLabelTextField(
                              readOnly: true,
                              controller: dateController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '排泄日期',
                              onTap: () {
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      color: UiColor.theme1Color,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _date,
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (datetime) {
                                          _date = datetime;
                                          dateController.text =
                                              datetime.formatDate();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              controller: timeController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              readOnly: true,
                              labelText: '排泄時間',
                              onTap: () {
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      color: UiColor.theme1Color,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _time,
                                        mode: CupertinoDatePickerMode.time,
                                        onDateTimeChanged: (datetime) {
                                          _time = datetime;
                                          timeController.text =
                                              datetime.formatTime();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              controller: situationController,
                              validator: (value) => Validators.stringValidator(
                                  value,
                                  errorMessage: '排泄情況'),
                              maxLines: 4,
                              labelText: '排泄情況',
                              hintText: '情況',
                            ),
                            const SizedBox(height: 25),
                            Stack(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    // maxWidth: 375,
                                    maxHeight: 320,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: UiColor.textinputColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: picture == null
                                        ? null
                                        : DecorationImage(
                                            image: MemoryImage(picture!)),
                                  ),
                                  child: AddPicture(
                                    visible: picture == null,
                                    onTap: () async {
                                      await ImageUtils.pickImage().then((img) {
                                        if (img != null) {
                                          picture = img;
                                          setState(() {});
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: picture != null,
                                  child: Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            size: 15, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            picture = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 42,
                  child: CustomButton(asyncOnPressed: submit, buttonText: '完成'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
