import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/pages/home/widgets/pet_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  @override
  Widget build(BuildContext context) {
    final petManagement = Provider.of<AppProvider>(context).petManagement;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("我的寵物清單"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: petManagement.length,
                itemBuilder: (context, index) {
                  return PetItem(
                    petManagement: petManagement[index],
                    petIndex: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
