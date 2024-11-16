import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/diet.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/diets_serivce.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:provider/provider.dart';

class EditDietPage extends StatefulWidget {
  final Diet diet;
  final bool editable;
  final int pmId;
  const EditDietPage({
    super.key,
    required this.diet,
    required this.editable,
    required this.pmId,
  });

  @override
  State<EditDietPage> createState() => _EditDietPageState();
}

class _EditDietPageState extends State<EditDietPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController quantityController = TextEditingController();
  TextEditingController situationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime _time = DateTime.now();

  Future<bool> checkPermission() async {
    bool editable = false;
    await PetManagementsService.getPetManagement(widget.pmId).then((pm) {
      editable = pm.pmPermissions != '3';
    });
    return editable;
  }

  @override
  void initState() {
    super.initState();
    quantityController.text = widget.diet.dietQuantity.toString();
    situationController.text = widget.diet.dietSituation!;
    dateController.text = widget.diet.dietDateTime.formatDate();
    timeController.text = widget.diet.dietDateTime.formatTime();
    _date = widget.diet.dietDateTime;
    _time = widget.diet.dietDateTime;
  }

  Future submit() async {
    if (!widget.editable) return;
    DateTime dateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    final dietData = {
      'Diet_ID': widget.diet.dietId,
      'Diet_PetID': widget.diet.dietPetId,
      'Diet_DateTimw': dateTime.toIso8601String(),
      'Diet_Quantity': quantityController.text,
      'Diet_Situation': situationController.text,
    };
    debugPrint(dietData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        if (await checkPermission() == false) {
          throw '沒有足夠的權限。';
        }
        await DietsService.updateDiet(widget.diet.dietId, dietData)
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
        title: const Text("飲食紀錄"),
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
                              labelText: '用餐日期',
                              onTap: () {
                                if (!widget.editable) return;
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
                              readOnly: true,
                              controller: timeController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '用餐時間',
                              onTap: () {
                                if (!widget.editable) return;
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
                              readOnly: !widget.editable,
                              controller: quantityController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '單位',
                                onlyInt: true,
                              ),
                              labelText: '單位',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              readOnly: !widget.editable,
                              controller: situationController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '用餐情況',
                              ),
                              labelText: '用餐情況',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (widget.editable)
                  SizedBox(
                    height: 42,
                    child:
                        CustomButton(asyncOnPressed: submit, buttonText: '完成'),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
