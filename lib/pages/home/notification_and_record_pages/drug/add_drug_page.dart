import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/durgs_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddDrugPage extends StatefulWidget {
  final int petId;
  const AddDrugPage({super.key, required this.petId});

  @override
  State<AddDrugPage> createState() => _AddDrugPageState();
}

class _AddDrugPageState extends State<AddDrugPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nextDateController = TextEditingController();
  DateTime _datetime = DateTime.now();
  DateTime _nextDatetime = DateTime.now();

  Future submit() async {
    final drugDate = {
      'Drug_PetID': widget.petId,
      'Drug_Name': nameController.text,
      'Drug_Dosage': dosageController.text,
      'Drug_Date': _datetime.toIso8601String(),
      'Drug_NextDate': _nextDatetime.toIso8601String(),
    };
    debugPrint(drugDate.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await DrugsService.createDrug(drugDate).then((_) async {
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
        title: const Text("新增藥物紀錄"),
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
                          errorMessage: '藥物名稱',
                        ),
                        labelText: '藥物名稱',
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: dosageController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '藥物劑量',
                          onlyInt: true,
                        ),
                        labelText: '藥物劑量',
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        readOnly: true,
                        controller: dateController,
                        validator: (value) =>
                            Validators.dateTimeValidator(value),
                        labelText: '服用日期',
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
                        labelText: '下次服用日期',
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