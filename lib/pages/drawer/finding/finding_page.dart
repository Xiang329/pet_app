import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/finding/found/add_found_page.dart';
import 'package:pet_app/pages/drawer/finding/found/all_found_list_page.dart';
import 'package:pet_app/pages/drawer/finding/missing/add_missing_page.dart';
import 'package:pet_app/pages/drawer/finding/finding_filter_page.dart';
import 'package:pet_app/pages/drawer/finding/missing/all_missing_list_page.dart';
import 'package:pet_app/pages/drawer/finding/my_finding_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FilterFieldState> filterFieldKey = GlobalKey();
  final List<(Finding, Pet)> missingList = [];
  final List<(Finding, Pet)> filteredMissingList = [];
  final List<Finding> foundList = [];
  final List<Finding> filteredFoundList = [];
  late TabController tabController;
  late Future loadData;
  bool isFiltering = false;
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(clearFilters);
    loadData = Provider.of<AppProvider>(context, listen: false)
        .fetchAllPetFindings()
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

  List<(Finding, Pet)> filterMissing(
    List<(Finding, Pet)> missingList, {
    String? classType,
    String? variety,
    String? city,
  }) {
    return missingList.where((values) {
      final matchesClass =
          classType == null || values.$2.className == classType;
      final matchesVariety =
          variety == null || values.$2.varietyName == variety;
      final matchesCity = city == null || values.$1.findingPlace.contains(city);
      return matchesClass && matchesVariety && matchesCity;
    }).toList();
  }

  List<Finding> filterFound(
    List<Finding> foundList, {
    String? classType,
    String? variety,
    String? city,
  }) {
    return foundList.where((values) {
      final matchesClass = classType == null || values.className == classType;
      final matchesVariety = variety == null || values.varietyName == variety;
      final matchesCity = city == null || values.findingPlace.contains(city);
      return matchesClass && matchesVariety && matchesCity;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    if (!hasLoaded) return;
    isFiltering = true;
    setState(() {
      if (tabController.index == 0) {
        filteredFoundList.clear();
        filteredFoundList.addAll(foundList);
        filteredMissingList.clear();
        filteredMissingList.addAll(filterMissing(
          missingList,
          classType: filters['class'],
          variety: filters['variety'],
          city: filters['city'],
        ));
      } else {
        filteredMissingList.clear();
        filteredMissingList.addAll(missingList);
        filteredFoundList.clear();
        filteredFoundList.addAll(filterFound(
          foundList,
          classType: filters['class'],
          variety: filters['variety'],
          city: filters['city'],
        ));
      }
    });
  }

  void clearFilters() {
    // setState(() {});
    filterFieldKey.currentState?.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        titleSpacing: 0,
        title: FilterField(
          key: filterFieldKey,
          useHorizontalScroll: true,
          filterPage: const FindingFilterPage(),
          onFilterApplied: applyFilters,
          margin: const EdgeInsets.all(0),
          maxHeight: 3,
        ),
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
                      builder: (BuildContext context) => const MyFindingPage()),
                );
              },
              icon: SvgPicture.asset(AssetsImages.articleSvg),
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          onTap: (value) {
            if (tabController.indexIsChanging) {
              clearFilters();
            }
          },
          indicatorColor: UiColor.text1Color,
          labelColor: UiColor.text1Color,
          unselectedLabelColor: UiColor.text2Color,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '遺失'),
            Tab(text: '拾獲'),
          ],
        ),
      ),
      body: Container(
        color: UiColor.theme1Color,
        child: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            hasLoaded = true;
            return TabBarView(
              controller: tabController,
              children: [
                AllMissingListPage(
                  missingList: missingList,
                  filteredMissingList: filteredMissingList,
                  isFiltering: isFiltering,
                ),
                AllFoundListPage(
                  foundList: foundList,
                  filteredFoundList: filteredFoundList,
                  isFiltering: isFiltering,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UiColor.theme2Color,
        shape: const CircleBorder(),
        onPressed: () {
          tabController.index == 0
              ? showModalBottomSheet(
                  clipBehavior: Clip.antiAlias,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  context: context,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.80,
                  ),
                  builder: (BuildContext context) {
                    return const AddMissingPage();
                  },
                )
              : Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const AddFoundPage()),
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
