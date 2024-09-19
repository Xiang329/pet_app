import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/vaccine.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/vaccines_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:pet_app/widgets/left_label_dropdown_list.dart';
import 'package:provider/provider.dart';

class EditVaccinePage extends StatefulWidget {
  final Vaccine vaccine;
  const EditVaccinePage({super.key, required this.vaccine});

  @override
  State<EditVaccinePage> createState() => _EditVaccinePageState();
}

class _EditVaccinePageState extends State<EditVaccinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nextDateController = TextEditingController();
  DateTime _datetime = DateTime.now();
  DateTime _nextDatetime = DateTime.now();

  String? selectedReaction;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.vaccine.vaccineName;
    selectedReaction = widget.vaccine.vaccineReaction ? '是' : '否';
    dateController.text = widget.vaccine.vaccineDate.formatDate();
    _datetime = widget.vaccine.vaccineDate;
    if (widget.vaccine.vaccineSymptom != null) {
      symptomController.text = widget.vaccine.vaccineSymptom!;
    }
    if (widget.vaccine.vaccineNextDate != null) {
      _nextDatetime = widget.vaccine.vaccineNextDate!;
      nextDateController.text = widget.vaccine.vaccineNextDate.formatDate();
    }
  }

  Future submit() async {
    final vaccineData = {
      'Vaccine_ID': widget.vaccine.vaccineId,
      'Vaccine_PetID': widget.vaccine.vaccinePetId,
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
        await VaccinesService.updateVaccine(
                widget.vaccine.vaccineId, vaccineData)
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
        title: const Text("疫苗紀錄"),
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
                Column(
                  children: [
                    Card(
                      color: UiColor.theme1Color,
                      shadowColor: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledLeftLabelTextField(
                              controller: nameController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '疫苗名稱',
                              ),
                              labelText: '疫苗名稱',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              readOnly: true,
                              controller: dateController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '施打日期',
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
                              controller: nextDateController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '下次施打日期',
                              onTap: () {
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  context: context,
                                  builder: (BuildContext context) {
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
                            const SizedBox(height: 25),
                            LeftLabelDropdownList(
                              validator: (value) =>
                                  Validators.dropDownListValidator(
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
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              controller: symptomController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '過敏症狀',
                              ),
                              maxLines: 4,
                              labelText: '過敏症狀',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
