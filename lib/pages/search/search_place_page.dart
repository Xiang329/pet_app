import 'dart:convert';

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
  bool hasLoaded = false;

  // 醫院相關
  Future? fetchHospitals;
  final List<Place> hospitalPlaces = [];
  final List<Place> filteredHospitalPlaces = [];
  String? hospitalsNextPageToken;
  bool isLoadingHospital = false;
  bool hasMoreHospitalsData = true;
  final ScrollController hospitalListScrollController = ScrollController();

  // 商店相關
  Future? fetchStores;
  final List<Place> storePlaces = [];
  final List<Place> filteredStorePlaces = [];
  String? storesNextPageToken;
  bool isLoadingStore = false;
  bool hasMoreStoresData = true;
  final ScrollController storeListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(clearFilters);
    hospitalListScrollController.addListener(() {
      // 滑動到底部後加載更多
      if (hasMoreHospitalsData &&
          hospitalListScrollController.position.pixels ==
              hospitalListScrollController.position.maxScrollExtent) {
        _fetchHospitals(refresh: false);
      }
    });
    storeListScrollController.addListener(() {
      // 滑動到底部後加載更多
      if (hasMoreStoresData &&
          storeListScrollController.position.pixels ==
              storeListScrollController.position.maxScrollExtent) {
        _fetchStores(refresh: false);
      }
    });
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

  Future<PlacesResponse> _fetchPlaces(String query,
      {String? nextPageToken}) async {
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
      'nextPageToken',
    ];

    final requestBody = {
      "textQuery": query,
      "pageSize": 20,
      "languageCode": "zh-TW",
      "locationBias": {
        "circle": {
          "center": {
            "latitude": currentLocation?.latitude ?? defaultPosition.$1,
            "longitude": currentLocation?.longitude ?? defaultPosition.$2,
          },
          "radius": 10000.0,
        }
      },
    };

    if (nextPageToken != null) {
      requestBody["pageToken"] = nextPageToken;
    }

    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchText'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': 'AIzaSyCuYwvp1_QoOP2Vd0VVGKMCjMYDyi0zL2w',
        'X-Goog-FieldMask': fieldMaskFields.join(','),
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final placesResponse = PlacesResponse.fromJson(jsonResponse);
      return placesResponse;
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> _fetchHospitals({bool refresh = true}) async {
    if (isLoadingHospital) return;
    isLoadingHospital = true;
    if (refresh == true) hospitalsNextPageToken = null;
    await _fetchPlaces("動物醫院", nextPageToken: hospitalsNextPageToken)
        .then((value) {
      if (hasMoreHospitalsData == false || refresh == true) {
        hospitalPlaces.clear();
        filteredHospitalPlaces.clear();
      }
      if (value.nextPageToken == null) {
        hospitalsNextPageToken = null;
        hasMoreHospitalsData = false;
      } else {
        hospitalsNextPageToken = value.nextPageToken;
        hasMoreHospitalsData = true;
      }
      hospitalPlaces.addAll(value.places);
      filteredHospitalPlaces.addAll(value.places);
    });
    isLoadingHospital = false;
    setState(() {});
  }

  Future<void> _fetchStores({bool refresh = true}) async {
    if (isLoadingStore) return;
    isLoadingStore = true;
    if (refresh == true) storesNextPageToken = null;
    await _fetchPlaces("動物商店", nextPageToken: storesNextPageToken)
        .then((value) {
      if (hasMoreStoresData == false || refresh == true) {
        storePlaces.clear();
        filteredStorePlaces.clear();
      }
      if (value.nextPageToken == null) {
        storesNextPageToken = null;
        hasMoreStoresData = false;
      } else {
        storesNextPageToken = value.nextPageToken;
        hasMoreStoresData = true;
      }
      storePlaces.addAll(value.places);
      filteredStorePlaces.addAll(value.places);
    });
    isLoadingStore = false;
    setState(() {});
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
          tabs: [
            Tab(text: '找醫院 (${filteredHospitalPlaces.length})'),
            Tab(text: '找商店 (${filteredStorePlaces.length})'),
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
                  controller: hospitalListScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: filteredHospitalPlaces.length + 1,
                  itemBuilder: (context, index) {
                    if (index < filteredHospitalPlaces.length) {
                      return HospitalItem(
                        hospital: filteredHospitalPlaces[index],
                        tabIndex: tabController.index,
                      );
                    } else {
                      return getMoreWidget(hasMoreHospitalsData);
                    }
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
                  controller: storeListScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: filteredStorePlaces.length + 1,
                  itemBuilder: (context, index) {
                    if (index < filteredStorePlaces.length) {
                      return ShopItem(
                        shop: filteredStorePlaces[index],
                        tabIndex: tabController.index,
                      );
                    } else {
                      return getMoreWidget(hasMoreStoresData);
                    }
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

  Widget getMoreWidget(bool hasMoreData) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              hasMoreData ? '讀取中...　' : '沒有更多資料了',
              style: const TextStyle(fontSize: 16.0),
            ),
            if (hasMoreData)
              const CircularProgressIndicator(
                strokeWidth: 2.0,
              )
          ],
        ),
      ),
    );
  }
}
