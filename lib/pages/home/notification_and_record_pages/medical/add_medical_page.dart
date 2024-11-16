import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/medicals_service.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddMedicalPage extends StatefulWidget {
  final int petId;
  final int pmId;
  const AddMedicalPage({
    super.key,
    required this.petId,
    required this.pmId,
  });

  @override
  State<AddMedicalPage> createState() => _AddMedicalPageState();
}

class _AddMedicalPageState extends State<AddMedicalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController clinicController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController doctorOrdersController = TextEditingController();
  DateTime _datetime = DateTime.now();

  Future<bool> checkPermission() async {
    bool editable = false;
    await PetManagementsService.getPetManagement(widget.pmId).then((pm) {
      editable = pm.pmPermissions != '3';
    });
    return editable;
  }

  Future submit() async {
    final medicalData = {
      'Medical_PetID': widget.petId,
      'Medical_Clinic': clinicController.text,
      'Medical_Date': _datetime.toIso8601String(),
      'Medical_Disease': diseaseController.text,
      'Medical_DoctorOrders': doctorOrdersController.text,
    };
    debugPrint(medicalData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        if (await checkPermission() == false) {
          throw '沒有足夠的權限。';
        }
        await MedicalsService.createMedical(medicalData).then((_) async {
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
        title: const Text("新增就醫紀錄"),
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
                        controller: clinicController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '看診診所',
                        ),
                        labelText: '看診診所',
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: dateController,
                        readOnly: true,
                        validator: (value) =>
                            Validators.dateTimeValidator(value),
                        labelText: '看診日期',
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
                        controller: diseaseController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '疾病或症狀',
                        ),
                        labelText: '疾病或症狀',
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: doctorOrdersController,
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '醫囑',
                        ),
                        labelText: '醫囑',
                        maxLines: 4,
                        alignLabelWithHint: true,
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
