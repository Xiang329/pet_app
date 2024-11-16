import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/excretions_serivce.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/add_picture.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddExcretionPage extends StatefulWidget {
  final int petId;
  final int pmId;
  const AddExcretionPage({
    super.key,
    required this.petId,
    required this.pmId,
  });

  @override
  State<AddExcretionPage> createState() => _AddExcretionPageState();
}

class _AddExcretionPageState extends State<AddExcretionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController situationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime _time = DateTime.now();
  Uint8List? picture;

  Future<bool> checkPermission() async {
    bool editable = false;
    await PetManagementsService.getPetManagement(widget.pmId).then((pm) {
      editable = pm.pmPermissions != '3';
    });
    return editable;
  }

  Future submit() async {
    DateTime dateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    final excretionData = {
      'Excretion_PetID': widget.petId,
      'Excretion_DateTime': dateTime.toIso8601String(),
      'Excretion_Situation': situationController.text,
      'Excretion_Picture': picture,
    };
    // debugPrint(excretionData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        if (await checkPermission() == false) {
          throw '沒有足夠的權限。';
        }
        await ExcretionsService.createExcretion(excretionData).then((_) async {
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
        title: const Text("新增排泄紀錄"),
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
                      OutlinedTextField(
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
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                dateController.text = _date.formatDate();
                              });
                              return Container(
                                height: 300,
                                color: UiColor.theme1Color,
                                child: CupertinoDatePicker(
                                  initialDateTime: _date,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (datetime) {
                                    _date = datetime;
                                    dateController.text = datetime.formatDate();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        readOnly: true,
                        controller: timeController,
                        validator: (value) =>
                            Validators.dateTimeValidator(value),
                        labelText: '排泄時間',
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            context: context,
                            builder: (BuildContext context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                timeController.text = _time.formatTime();
                              });
                              return Container(
                                height: 300,
                                color: UiColor.theme1Color,
                                child: CupertinoDatePicker(
                                  initialDateTime: _time,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (datetime) {
                                    _time = datetime;
                                    timeController.text = datetime.formatTime();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: situationController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '排泄情況',
                        ),
                        labelText: '排泄情況',
                        hintText: '情況',
                        maxLines: 4,
                        alignLabelWithHint: true,
                      ),
                      const SizedBox(height: 24),
                      Align(
                        child: Container(
                          height: 320,
                          width: 320,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 2,
                              color: UiColor.navigationBarColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            image: picture == null
                                ? null
                                : DecorationImage(image: MemoryImage(picture!)),
                          ),
                          child: Stack(
                            children: [
                              AddPicture(
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
