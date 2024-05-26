import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/hospital.dart';
import 'package:pet_app/models/shop.dart';
import 'package:pet_app/pages/drawer/finding/found/add_found_page.dart';
import 'package:pet_app/pages/drawer/finding/found/widgets/found_list_item.dart';
import 'package:pet_app/pages/drawer/finding/missing/add_missing_page.dart';
import 'package:pet_app/pages/drawer/finding/finding_filter_page.dart';
import 'package:pet_app/pages/drawer/finding/missing/widgets/missing_list_item.dart';
import 'package:pet_app/pages/drawer/finding/my_finding_page.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:flutter/material.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController tabController;

  List<Hospital> hospitals = [
    Hospital("Hospital1", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital2", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital3", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital4", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital5", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital6", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
    Hospital("Hospital7", "241新北市三重區重陽路一段20巷4號1樓", "0229719531", 5),
  ];
  List<Shop> shops = [
    Shop("Shop1", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop2", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop3", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop4", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop5", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop6", "241新北市三重區中正北路510號", "0229821666", 5),
    Shop("Shop7", "241新北市三重區中正北路510號", "0229821666", 5),
  ];

  var initHospitalsItems = [];
  var initshopsItems = [];

  void _handleTabSelection() {
    setState(() {
      searchController.text = '';
      hospitalsSearchResults('');
      shopsSearchResults('');
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabSelection);
    initHospitalsItems = hospitals;
    initshopsItems = shops;
    super.initState();
  }

  void hospitalsSearchResults(String query) {
    setState(() {
      initHospitalsItems = hospitals
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void shopsSearchResults(String query) {
    setState(() {
      initshopsItems = shops
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UiColor.theme2_color,
          titleSpacing: 0,
          title: const FilterField(
            useHorizontalScroll: true,
            filterPage: FindingFilterPage(),
            margin: EdgeInsets.all(0),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            SizedBox(
              height: 56,
              width: 56,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const MyFindingPage()),
                  );
                },
                icon: const Icon(Icons.my_library_books),
              ),
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            onTap: (value) {
              _handleTabSelection();
            },
            indicatorColor: UiColor.text1_color,
            labelColor: UiColor.text1_color,
            unselectedLabelColor: UiColor.text2_color,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: '遺失'),
              Tab(text: '拾獲'),
            ],
          ),
        ),
        body: Container(
          color: UiColor.theme1_color,
          child: TabBarView(
            controller: tabController,
            children: [
              ListView.separated(
                itemCount: initHospitalsItems.length,
                itemBuilder: (context, index) {
                  return const MissingListItem();
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 0),
              ),
              ListView.separated(
                itemCount: initshopsItems.length,
                itemBuilder: (context, index) {
                  return const FoundListItem();
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 0),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: UiColor.theme2_color,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => tabController.index == 0
                    ? const AddMissingPage()
                    : const AddFoundPage(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
