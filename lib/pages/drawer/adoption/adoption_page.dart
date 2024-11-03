import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/animal.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_filter_page.dart';
import 'package:pet_app/pages/drawer/adoption/widgets/adoption_list_item.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:pet_app/widgets/no_results.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key});

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  final ScrollController _scrollController = ScrollController();
  List<Animal> animals = [];
  List<Animal> filteredAnimals = [];
  String? animalKind, animalVariety, animalSex, shelterName;
  int currentPage = 1;
  bool isFiltering = false;
  bool isLoading = false;
  bool hasMoreData = true;
  late Future loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadAnimalData();
    _scrollController.addListener(() {
      // 滑動到底部後加載更多
      if (hasMoreData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        loadAnimalData();
      }
    });
  }

  void applyFilters(Map<String, String> filters) {
    isFiltering = true;
    setState(() {
      currentPage = 1;
      hasMoreData = true;
      animals.clear();
      filteredAnimals.clear();
      animalKind = filters['kind'];
      animalVariety = filters['variety'];
      animalSex = filters['sex'];
      shelterName = filters['shelter'];
      loadData = loadAnimalData();
    });
  }

  Future loadAnimalData() async {
    if (isLoading) return;
    isLoading = true;
    String apiUrl =
        'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL&\$top=10&\$skip=${(currentPage - 1) * 10}';

    List<String> filters = [];
    if (animalKind != null && animalKind!.isNotEmpty) {
      filters.add('animal_kind=${Uri.encodeComponent(animalKind!)}');
    }
    if (animalVariety != null && animalVariety!.isNotEmpty) {
      filters.add('animal_Variety=${Uri.encodeComponent(animalVariety!)}');
    }
    if (animalSex != null && animalSex!.isNotEmpty) {
      const Map<String, String> sex = {'M': '公', 'F': '母', 'N': '未輸入'};
      String matchSex = sex.keys.firstWhere((key) => sex[key] == animalSex);
      filters.add('animal_sex=${Uri.encodeComponent(matchSex)}');
    }
    if (shelterName != null && shelterName!.isNotEmpty) {
      filters.add('shelter_name=${Uri.encodeComponent(shelterName!)}');
    }

    if (filters.isNotEmpty) {
      final filtersString = filters.join('&');
      apiUrl = '$apiUrl&$filtersString';
    }
    debugPrint(Uri.decodeComponent(apiUrl));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result.isNotEmpty) {
          setState(() {
            currentPage++;
            animals.addAll(
                List<Animal>.from(result.map((x) => Animal.fromJson(x))));
            filteredAnimals = animals;
            if (animals.length < 10) hasMoreData = false;
          });
        } else {
          setState(() {
            hasMoreData = false;
          });
        }
      }
    } on http.ClientException catch (e) {
      if (e.message == 'XMLHttpRequest error.') {
        setState(() {
          hasMoreData = false;
        });
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('錯誤'),
              content: const Text('無法連線至伺服器，請檢查網路連線。'),
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
      }
      throw (e.toString());
    } catch (e) {
      setState(() {
        hasMoreData = false;
      });
      debugPrint(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("認領養資訊"),
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
          FilterField(
            filterPage: const AdoptionFilterPage(),
            onFilterApplied: applyFilters,
          ),
          Expanded(
            child: FutureBuilder(
                future: loadData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (isFiltering && filteredAnimals.isEmpty) {
                    return const Center(child: NoResults());
                  }
                  if (filteredAnimals.isEmpty) {
                    return const Center(child: EmptyData());
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: filteredAnimals.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredAnimals.length) {
                        return AdoptionListItem(animal: filteredAnimals[index]);
                      } else {
                        return getMoreWidget(hasMoreData);
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  );
                }),
          ),
        ],
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
