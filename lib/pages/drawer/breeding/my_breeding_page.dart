import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/breeding/widgets/breeding_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class MyBreedingPage extends StatefulWidget {
  const MyBreedingPage({super.key});

  @override
  State<MyBreedingPage> createState() => _MyBreedingPageState();
}

class _MyBreedingPageState extends State<MyBreedingPage> {
  late Future loadData;

  @override
  void initState() {
    super.initState();
    loadData =
        Provider.of<AppProvider>(context, listen: false).fetchMyPetBreedings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("我的寵物配種"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: loadData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Selector<AppProvider, List<(Breeding, Pet)>>(
                      selector: (context, appProvider) => appProvider.myBreedingList,
                      shouldRebuild: (previous, next) => listEquals(previous, next),
                      builder: (context, myBreedingList, child) {
                        if (myBreedingList.isEmpty) {
                          return const Center(child: EmptyData());
                        }
                        return ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: myBreedingList.length,
                          itemBuilder: (context, index) {
                            return BreedingListItem(
                              breedingId: myBreedingList[index].$1.breedingId,
                              petId: myBreedingList[index].$1.breedingPetId,
                              pet: myBreedingList[index].$2,
                              editable: true,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 0),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
