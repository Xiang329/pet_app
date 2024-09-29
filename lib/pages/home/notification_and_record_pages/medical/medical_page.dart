import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/medical/add_medical_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/medical/edit_medical_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/pages/home/widgets/slidable_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class MedicalPage extends StatefulWidget {
  final int petIndex;
  final bool editable;
  const MedicalPage({
    super.key,
    required this.petIndex,
    required this.editable,
  });

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  @override
  Widget build(BuildContext context) {
    final petId = Provider.of<AppProvider>(context)
        .petManagement[widget.petIndex]
        .pet!
        .petId;
    final medicalList = Provider.of<AppProvider>(context)
        .petManagement[widget.petIndex]
        .pet!
        .medicalList;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("就醫紀錄"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        if (medicalList.isEmpty) {
          return const Center(
              child: EmptyData(
            text: '尚無紀錄',
          ));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SlidableAutoCloseBehavior(
                // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
                // 否則出錯A dismissed Slidable widget is still part of the tree.
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: medicalList.length,
                  itemBuilder: (context, index) {
                    return SlidableItem(
                      medical: medicalList[index],
                      editable: widget.editable,
                      onTap: () {
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.90,
                          ),
                          builder: (BuildContext context) {
                            return Navigator(
                              onGenerateRoute: (settings) {
                                return CupertinoPageRoute(
                                  builder: (context) => EditMedicalPage(
                                    medical: medicalList[index],
                                    editable: widget.editable,
                                  ),
                                  settings: settings,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: !widget.editable
          ? null
          : FloatingActionButton(
              backgroundColor: UiColor.theme2Color,
              shape: const CircleBorder(),
              onPressed: () {
                showModalBottomSheet(
                  clipBehavior: Clip.antiAlias,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.90,
                  ),
                  builder: (BuildContext context) {
                    return Navigator(
                      onGenerateRoute: (settings) {
                        return CupertinoPageRoute(
                          builder: (context) => AddMedicalPage(
                            petId: petId,
                          ),
                          settings: settings,
                        );
                      },
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
    );
  }
}
