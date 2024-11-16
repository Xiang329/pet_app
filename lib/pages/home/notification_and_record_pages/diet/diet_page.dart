import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/diet.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/diet/add_diet_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/diet/edit_diet_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/pages/home/widgets/slidable_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class DietPage extends StatefulWidget {
  final int pmId;
  const DietPage({
    super.key,
    required this.pmId,
  });

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  @override
  Widget build(BuildContext context) {
    PetManagement? petManagemnet;
    Pet? pet;
    List<Diet> dietList = [];
    bool editable = false;
    final appProvider = Provider.of<AppProvider>(context);
    petManagemnet = appProvider.petManagement
        .firstWhereOrNull((petManagement) => petManagement.pmId == widget.pmId);
    if (petManagemnet != null) {
      pet = petManagemnet.pet;
      dietList = petManagemnet.pet!.dietList;
      editable = petManagemnet.pmPermissions != '3';
    }

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("飲食紀錄"),
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
        if (dietList.isEmpty) {
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
                  itemCount: dietList.length,
                  itemBuilder: (context, index) {
                    return SlidableItem(
                      diet: dietList[index],
                      editable: editable,
                      pmId: widget.pmId,
                      onTap: () {
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.70,
                          ),
                          builder: (BuildContext context) {
                            return Navigator(
                              onGenerateRoute: (settings) {
                                return CupertinoPageRoute(
                                  builder: (context) => EditDietPage(
                                    diet: dietList[index],
                                    editable: editable,
                                    pmId: widget.pmId,
                                  ),
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
      floatingActionButton: !editable
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
                    maxHeight: MediaQuery.of(context).size.height * 0.70,
                  ),
                  builder: (BuildContext context) {
                    return Navigator(
                      onGenerateRoute: (settings) {
                        return CupertinoPageRoute(
                          builder: (context) => AddDietPage(
                            petId: pet!.petId,
                            pmId: widget.pmId,
                          ),
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
