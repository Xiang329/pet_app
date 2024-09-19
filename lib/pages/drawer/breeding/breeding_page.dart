import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/breeding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/breeding/add_breeding_page.dart';
import 'package:pet_app/pages/drawer/breeding/breeding_filter_page.dart';
import 'package:pet_app/pages/drawer/breeding/my_breeding_page.dart';
import 'package:pet_app/pages/drawer/breeding/widgets/breeding_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:pet_app/widgets/no_results.dart';
import 'package:provider/provider.dart';

class BreedingPage extends StatefulWidget {
  const BreedingPage({super.key});

  @override
  State<BreedingPage> createState() => _BreedingPageState();
}

class _BreedingPageState extends State<BreedingPage> {
  final List<(Breeding, Pet)> breedingList = [];
  final List<(Breeding, Pet)> filteredBreedingList = [];
  late Future loadData;
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    loadData = Provider.of<AppProvider>(context, listen: false)
        .fetchAllPetBreedings()
        .catchError((e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
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
    });
  }

  List<(Breeding, Pet)> filterBreeding(
    List<(Breeding, Pet)> breedingList, {
    String? classType,
    String? variety,
    String? sex,
  }) {
    return breedingList.where((values) {
      final matchesClass =
          classType == null || values.$2.className == classType;
      final matchesVariety =
          variety == null || values.$2.varietyName == variety;
      final matchesSex = sex == null || (values.$2.petSex ? '男' : '女') == sex;
      return matchesClass && matchesVariety && matchesSex;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    isFiltering = true;
    setState(() {
      filteredBreedingList.clear();
      filteredBreedingList.addAll(filterBreeding(
        breedingList,
        classType: filters['class'],
        variety: filters['variety'],
        sex: filters['sex'],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("寵物配種"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) => const MyBreedingPage(),
                  ),
                );
              },
              icon: SvgPicture.asset(AssetsImages.articleSvg),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterField(
            filterPage: const BreedingFilterPage(),
            onFilterApplied: applyFilters,
            maxHeight: 3,
          ),
          Expanded(
            child: FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Selector<AppProvider, List<(Breeding, Pet)>>(
                  selector: (context, appProvider) => appProvider.allBreedingsList,
                  shouldRebuild:(previous, next) => previous != next,
                  builder: (context, allBreedingsList, child) {
                    breedingList.clear();
                    breedingList.addAll(List.from(allBreedingsList));
                    if (!isFiltering) {
                      filteredBreedingList.clear();
                      filteredBreedingList.addAll(List.from(allBreedingsList));
                    }
                    if (isFiltering && filteredBreedingList.isEmpty) {
                      return const NoResults();
                    }
                    if (allBreedingsList.isEmpty) {
                      return const Center(child: EmptyData());
                    }
                    isFiltering = false;
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: filteredBreedingList.length,
                      itemBuilder: (context, index) {
                        return BreedingListItem(
                          breedingId: filteredBreedingList[index].$1.breedingId,
                          petId: filteredBreedingList[index].$1.breedingPetId,
                          pet: filteredBreedingList[index].$2,
                          editable: false,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 0),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UiColor.theme2Color,
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            clipBehavior: Clip.antiAlias,
            useRootNavigator: true,
            isScrollControlled: true,
            context: context,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.80,
            ),
            builder: (BuildContext context) {
              return const AddBreedingPage();
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
