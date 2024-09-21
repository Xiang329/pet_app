import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/vaccines_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddVaccinePage extends StatefulWidget {
  final int petId;
  const AddVaccinePage({super.key, required this.petId});

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nextDateController = TextEditingController();
  TextEditingController reactionController = TextEditingController();
  DateTime _datetime = DateTime.now();
  DateTime _nextDatetime = DateTime.now();

  String? selectedReaction;

  Future submit() async {
    final vaccineData = {
      'Vaccine_PetID': widget.petId,
      'Vaccine_Date': _datetime.toIso8601String(),
      'Vaccine_Name': nameController.text,
      'Vaccine_NextDate': nextDateController.text.isNotEmpty
          ? _nextDatetime.toIso8601String()
          : null,
      'Vaccine_reaction': selectedReaction == '是',
      'Vaccine_symptom': symptomController.text.isNotEmpty
          ? symptomController.text.isNotEmpty
          : null,
    };
    debugPrint(vaccineData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await VaccinesService.createVaccine(vaccineData).then((_) async {
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
        title: const Text("新增疫苗紀錄"),
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
                        controller: nameController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '疫苗名稱',
                        ),
                        labelText: '疫苗名稱',
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        readOnly: true,
                        controller: dateController,
                        validator: (value) =>
                            Validators.dateTimeValidator(value),
                        labelText: '施打日期',
                        hintText: '日期',
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            context: context,
                            builder: (BuildContext context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                dateController.text = _datetime.formatDate();
                              });
                              return Container(
                                height: 300,
                                color: UiColor.theme1Color,
                                child: CupertinoDatePicker(
                                  initialDateTime: _datetime,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (datetime) {
                                    _datetime = datetime;
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
                        controller: nextDateController,
                        validator: (value) =>
                            Validators.dateTimeValidator(value),
                        labelText: '下次施打日期',
                        hintText: '日期',
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            context: context,
                            builder: (BuildContext context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                nextDateController.text = _nextDatetime.formatDate();
                              });
                              return Container(
                                height: 300,
                                color: UiColor.theme1Color,
                                child: CupertinoDatePicker(
                                  initialDateTime: _nextDatetime,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (datetime) {
                                    _nextDatetime = datetime;
                                    nextDateController.text =
                                        datetime.formatDate();
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      DropdownList(
                        validator: (value) => Validators.dropDownListValidator(
                          value,
                          errorMessage: '是否過敏',
                        ),
                        title: '是否過敏',
                        items: const ['是', '否'],
                        value: selectedReaction,
                        onChanged: (String? value) {
                          setState(() {
                            selectedReaction = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: symptomController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '過敏症狀',
                        ),
                        labelText: '過敏症狀',
                        maxLines: 4,
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
