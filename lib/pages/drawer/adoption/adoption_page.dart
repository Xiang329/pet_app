import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/animal.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_filter_page.dart';
import 'package:pet_app/pages/drawer/adoption/widgets/adoption_list_item.dart';
import 'package:pet_app/widgets/filter_field.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key});

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  List<Animal> animals = [];
  List<Animal> filteredAnimals = [];
  bool loaded = false;

  Future loadData() async {
    if (loaded == true) return;
    loaded = true;
    try {
      String apiUri =
          r"https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL&$top=50";
      final response = await http.get(Uri.parse(apiUri));
      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);
        animals =
            List<Animal>.from((result as List).map((x) => Animal.fromJson(x)));
        filteredAnimals = animals;
        return animals;
      }
    } catch (e) {
      print(e);
    }
  }

  List<Animal> filterAnimals(List<Animal> animals,
      {String? kind, String? variety, String? shelter, String? sex}) {
    return animals.where((animal) {
      final matchesKind = kind == null || animal.animalKind == kind;
      final matchesVariety = variety == null || animal.animalVariety == variety;
      final matchesShelter = shelter == null || animal.shelterName == shelter;
      final matchesSex = sex == null || animal.animalSex == sex;
      return matchesKind && matchesVariety && matchesShelter && matchesSex;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    setState(() {
      filteredAnimals = filterAnimals(
        animals,
        kind: filters['kind'],
        variety: filters['variety'],
        shelter: filters['shelter'],
        sex: filters['sex'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("認領養資訊"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          FilterField(
            filterPage: const AdoptionFilterPage(),
            onFilterApplied: applyFilters,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredAnimals.length,
                          itemBuilder: (context, index) {
                            return AdoptionListItem(
                              animal: filteredAnimals[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 0),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UiColor.theme2_color,
        shape: const CircleBorder(),
        onPressed: () {
          for (var element in filterAnimals(animals, sex: "公")) {
            print(element);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
