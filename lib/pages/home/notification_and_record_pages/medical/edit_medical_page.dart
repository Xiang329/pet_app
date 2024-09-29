import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/medical.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/medicals_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:provider/provider.dart';

class EditMedicalPage extends StatefulWidget {
  final Medical medical;
  final bool editable;
  const EditMedicalPage({
    super.key,
    required this.medical,
    required this.editable,
  });

  @override
  State<EditMedicalPage> createState() => _EditMedicalPageState();
}

class _EditMedicalPageState extends State<EditMedicalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController clinicController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController doctorOrdersController = TextEditingController();
  DateTime _datetime = DateTime.now();

  Future submit() async {
    if (!widget.editable) return;
    final medicalData = {
      'Medical_ID': widget.medical.medicalId,
      'Medical_PetID': widget.medical.medicalPetId,
      'Medical_Clinic': clinicController.text,
      'Medical_Date': _datetime.toIso8601String(),
      'Medical_Disease': diseaseController.text,
      'Medical_DoctorOrders': doctorOrdersController.text,
    };
    debugPrint(medicalData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await MedicalsService.updateMedical(
                widget.medical.medicalId, medicalData)
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
  void initState() {
    super.initState();
    clinicController.text = widget.medical.medicalClinic!;
    diseaseController.text = widget.medical.medicalDisease;
    doctorOrdersController.text = widget.medical.medicalDoctorOrders!;
    dateController.text = widget.medical.medicalDate.formatDate();
    _datetime = widget.medical.medicalDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("就醫紀錄"),
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
                      clipBehavior: Clip.antiAlias,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledLeftLabelTextField(
                              readOnly: !widget.editable,
                              controller: clinicController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '看診診所',
                              ),
                              labelText: '看診診所',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              readOnly: true,
                              controller: dateController,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '看診日期',
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
                              readOnly: !widget.editable,
                              controller: diseaseController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '疾病或症狀',
                              ),
                              labelText: '疾病或症狀',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              readOnly: !widget.editable,
                              controller: doctorOrdersController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '醫囑',
                              ),
                              maxLines: 4,
                              labelText: '醫囑',
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
