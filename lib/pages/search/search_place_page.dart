import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/hospital.dart';
import 'package:pet_app/models/shop.dart';
import 'package:pet_app/pages/search/widgets/hospital_list_item.dart';
import 'package:pet_app/pages/search/widgets/shop_list_item.dart';
import 'package:flutter/material.dart';

class SearchPlacePage extends StatefulWidget {
  const SearchPlacePage({super.key});

  @override
  State<SearchPlacePage> createState() => _SearchPlacePageState();
}

class _SearchPlacePageState extends State<SearchPlacePage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController tabController;

  List<Hospital> hospitals = [
    Hospital('Hospital1', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 5.0),
    Hospital('Hospital2', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 4.5),
    Hospital('Hospital3', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 4.0),
    Hospital('Hospital4', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 3.5),
    Hospital('Hospital5', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 3.0),
    Hospital('Hospital6', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 2.5),
    Hospital('Hospital7', '241新北市三重區重陽路一段20巷4號1樓', '0229719531', 2.0),
  ];
  List<Shop> shops = [
    Shop('Shop1', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop2', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop3', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop4', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop5', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop6', '241新北市三重區中正北路510號', '0229821666', 5.0),
    Shop('Shop7', '241新北市三重區中正北路510號', '0229821666', 5.0),
  ];

  var hospitalsItems = [];
  var shopItems = [];

  void _clearSearchResults() {
    setState(() {
      searchController.text = '';
      hospitalsSearchResults('');
      shopsSearchResults('');
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_clearSearchResults);
    hospitalsItems = hospitals;
    shopItems = shops;
    super.initState();
  }

  void hospitalsSearchResults(String query) {
    setState(() {
      hospitalsItems = hospitals
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void shopsSearchResults(String query) {
    setState(() {
      shopItems = shops
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
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            onChanged: (value) {
              if (tabController.index == 0) {
                hospitalsSearchResults(value);
              } else {
                shopsSearchResults(value);
              }
            },
            style: const TextStyle(color: UiColor.text1_color),
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: SvgPicture.asset(
                  AssetsImages.searchSvg,
                  height: 14,
                  width: 14,
                ),
              ),
              hintText: '搜尋',
              hintStyle: const TextStyle(
                  color: UiColor.text1_color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              fillColor: UiColor.textinput_color,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          onTap: (value) {
            _clearSearchResults();
          },
          indicatorColor: UiColor.text1_color,
          labelColor: UiColor.text1_color,
          unselectedLabelColor: UiColor.text2_color,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '找醫院'),
            Tab(text: '找商店'),
          ],
        ),
      ),
      body: Container(
        color: UiColor.theme1_color,
        child: TabBarView(
          controller: tabController,
          children: [
            ListView.separated(
              itemCount: hospitalsItems.length,
              itemBuilder: (context, index) {
                return HospitalItem(
                  hospital: hospitalsItems[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 0),
            ),
            ListView.separated(
              itemCount: shopItems.length,
              itemBuilder: (context, index) {
                return ShopItem(
                  shop: shopItems[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
