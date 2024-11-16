import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/advice.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/advices_serivce.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:provider/provider.dart';

class EditNotificationPage extends StatefulWidget {
  final Advice advicd;
  final bool editable;
  final int pmId;
  const EditNotificationPage({
    super.key,
    required this.advicd,
    required this.editable,
    required this.pmId,
  });

  @override
  State<EditNotificationPage> createState() => _EditNotificationPageState();
}

class _EditNotificationPageState extends State<EditNotificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey _dialogKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime _time = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.advicd.adviceTitle;
    contentController.text = widget.advicd.adviceContent;
    placeController.text = widget.advicd.advicePlace;
    dateController.text = widget.advicd.adviceDateTime.formatDate();
    timeController.text = widget.advicd.adviceDateTime.formatTime();
    _date = widget.advicd.adviceDateTime;
    _time = widget.advicd.adviceDateTime;
  }

  Future<bool> checkPermission() async {
    bool editable = false;
    await PetManagementsService.getPetManagement(widget.pmId).then((pm) {
      editable = pm.pmPermissions != '3';
    });
    return editable;
  }

  Future submit() async {
    if (!widget.editable) return;
    DateTime dateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    final adviceData = {
      'Advice_ID': widget.advicd.adviceId,
      'Advice_PetID': widget.advicd.advicePetId,
      'Advice_Title': titleController.text,
      'Advice_Content': contentController.text,
      'Advice_DateTime': dateTime.toIso8601String(),
      'Advice_Place': placeController.text,
    };
    debugPrint(adviceData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        if (await checkPermission() == false) {
          throw '沒有足夠的權限。';
        }
        await AdvicesService.updateAdvice(widget.advicd.adviceId, adviceData)
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
        title: const Text("通知"),
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
                              readOnly: !widget.editable,
                              controller: titleController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '事項主題',
                              ),
                              labelText: '事項主題',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              controller: dateController,
                              readOnly: true,
                              validator: (value) =>
                                  Validators.dateTimeValidator(value),
                              labelText: '事項日期',
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
                              labelText: '事項時間',
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
                              controller: placeController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '事項地點',
                              ),
                              labelText: '事項地點',
                            ),
                            const SizedBox(height: 25),
                            FilledLeftLabelTextField(
                              readOnly: !widget.editable,
                              controller: contentController,
                              validator: (value) => Validators.stringValidator(
                                value,
                                errorMessage: '內容說明',
                              ),
                              maxLines: 4,
                              labelText: '內容說明',
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
