import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/place.dart';
import 'package:pet_app/pages/search/search_filter_page.dart';
import 'package:pet_app/pages/search/widgets/hospital_list_item.dart';
import 'package:pet_app/pages/search/widgets/shop_list_item.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:pet_app/widgets/no_results.dart';

class SearchPlacePage extends StatefulWidget {
  const SearchPlacePage({super.key});

  @override
  State<SearchPlacePage> createState() => SearchPlacePageState();
}

class SearchPlacePageState extends State<SearchPlacePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FilterFieldState> filterFieldKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  late TabController tabController;
  // 臺北市經緯度
  final defaultPosition = ('25.0329694', '121.5654177');
  Position? currentLocation;
  Future? fetchHospitals;
  Future? fetchStores;
  List<Place> hospitalPlaces = [];
  List<Place> storePlaces = [];
  final List<Place> filteredHospitalPlaces = [];
  final List<Place> filteredStorePlaces = [];
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(clearFilters);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSearchData();
    });
  }

  Future<void> _loadSearchData() async {
    try {
      await _determinePosition();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      try {
        await Future.wait([
          fetchHospitals = _fetchHospitals(),
          fetchStores = _fetchStores(),
        ]).whenComplete(() {
          setState(() {});
        });
      } catch (e) {
        debugPrint('Place錯誤${e.toString()}');
      }
    }
  }

  Future<void> loadDataWithDailog() async {
    if (!hasLoaded) return;
    await CommonDialog.showRefreshDialog(
      context: context,
      futureFunction: _loadSearchData,
    );
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 先檢查有無開啟定位功能
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 檢查有無開啟定位權限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Android預設若拒絕兩次則會永久關閉(deniedForever)，使用者需至設定中手動開啟
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.unableToDetermine) {
      return Future.error('Location permissions are denied');
    }

    // 如成功取得權限，使用以下function取得位置
    final position = await Geolocator.getCurrentPosition();
    currentLocation = position;
  }

  Future<PlacesResponse> _fetchPlaces(String query) async {
    if (currentLocation == null) {
      debugPrint('搜尋位置:$query，預設位置');
    } else {
      debugPrint('搜尋位置:$query，裝置定位位置');
    }
    debugPrint(
        "(latitude:${currentLocation?.latitude ?? defaultPosition.$1},longitude:${currentLocation?.longitude ?? defaultPosition.$2})");
    // 遮罩
    final List<String> fieldMaskFields = [
      // '*',
      'places.displayName',
      'places.formattedAddress',
      'places.nationalPhoneNumber',
      'places.location',
      'places.googleMapsUri',
      'places.regularOpeningHours.weekdayDescriptions',
      'places.rating',
      'places.userRatingCount',
    ];
    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchText'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': 'AIzaSyCuYwvp1_QoOP2Vd0VVGKMCjMYDyi0zL2w',
        'X-Goog-FieldMask': fieldMaskFields.join(','),
      },
      body: json.encode({
        "textQuery": query,
        "pageSize": 20,
        "languageCode": "zh-TW",
        "locationBias": {
          "circle": {
            "center": {
              "latitude": currentLocation?.latitude ?? defaultPosition.$1,
              "longitude": currentLocation?.longitude ?? defaultPosition.$2
            },
            "radius": 10000.0
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final placesResponse = PlacesResponse.fromJson(jsonResponse);
      return placesResponse;
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> _fetchHospitals() async {
    await _fetchPlaces("動物醫院").then((value) {
      hospitalPlaces.clear();
      filteredHospitalPlaces.clear();
      hospitalPlaces.addAll(value.places);
      filteredHospitalPlaces.addAll(value.places);
    });
  }

  Future<void> _fetchStores() async {
    await _fetchPlaces("動物商店").then((value) {
      storePlaces.clear();
      filteredStorePlaces.clear();
      storePlaces.addAll(value.places);
      filteredStorePlaces.addAll(value.places);
    });
  }

  List<Place> filterHospital(
    List<Place> placeList, {
    String? city,
    String? district,
  }) {
    return placeList.where((values) {
      final matchesCity =
          city == null || values.formattedAddress.contains(city);
      final matchesDistrict =
          district == null || values.formattedAddress.contains(district);
      return matchesCity && matchesDistrict;
    }).toList();
  }

  List<Place> filterStore(
    List<Place> placeList, {
    String? city,
    String? district,
  }) {
    return placeList.where((values) {
      final matchesCity =
          city == null || values.formattedAddress.contains(city);
      final matchesDistrict =
          district == null || values.formattedAddress.contains(district);
      return matchesCity && matchesDistrict;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    if (!hasLoaded) return;
    setState(() {
      if (tabController.index == 0) {
        filteredStorePlaces.clear();
        filteredStorePlaces.addAll(storePlaces);
        filteredHospitalPlaces.clear();
        filteredHospitalPlaces.addAll(filterHospital(
          hospitalPlaces,
          city: filters['city'],
          district: filters['district'],
        ));
      } else {
        filteredHospitalPlaces.clear();
        filteredHospitalPlaces.addAll(hospitalPlaces);
        filteredStorePlaces.clear();
        filteredStorePlaces.addAll(filterStore(
          storePlaces,
          city: filters['city'],
          district: filters['district'],
        ));
      }
    });
  }

  void clearFilters() {
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
          filterPage: const SearchFilterPage(),
          onFilterApplied: applyFilters,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          maxHeight: 2,
        ),
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
            Tab(text: '找醫院'),
            Tab(text: '找商店'),
          ],
        ),
      ),
      body: Container(
        color: UiColor.theme1Color,
        child: TabBarView(
          controller: tabController,
          children: [
            FutureBuilder(
              future: fetchHospitals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  hasLoaded = true;
                  if (filteredHospitalPlaces.isEmpty) {
                    return const Center(child: NoResults());
                  }
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: filteredHospitalPlaces.length,
                  itemBuilder: (context, index) {
                    return HospitalItem(
                      hospital: filteredHospitalPlaces[index],
                      tabIndex: tabController.index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                );
              },
            ),
            FutureBuilder(
              future: fetchStores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  hasLoaded = true;
                  if (filteredStorePlaces.isEmpty) {
                    return const NoResults();
                  }
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: filteredStorePlaces.length,
                  itemBuilder: (context, index) {
                    return ShopItem(
                      shop: filteredStorePlaces[index],
                      tabIndex: tabController.index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
