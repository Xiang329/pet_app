import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/pet_knowledge.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_filter_page.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/widgets/pet_knowledge_list_item.dart';
import 'package:pet_app/widgets/filter_field.dart';

class PetKnowledgePage extends StatefulWidget {
  const PetKnowledgePage({super.key});

  @override
  State<PetKnowledgePage> createState() => _PetKnowledgePageState();
}

class _PetKnowledgePageState extends State<PetKnowledgePage> {
  List<PetKnowledge> article = [];
  List<PetKnowledge> filteredArticle = [];
  bool loaded = false;

  Future loadData() async {
    if (loaded == true) return;
    loaded = true;
    try {
      String apiUri = "http://34.81.244.36/api/PetKnowledges";
      final response = await http.get(Uri.parse(apiUri));
      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);
        article = List<PetKnowledge>.from(
            (result as List).map((x) => PetKnowledge.fromJson(x)));
        filteredArticle = article;
        return article;
      }
    } catch (e) {
      print(e);
    }
  }

  List<PetKnowledge> filterArticle(List<PetKnowledge> article,
      {String? kind, String? variety, String? age, String? weight}) {
    return article.where((petKnwoledge) {
      final matchesKind = kind == null || petKnwoledge.className == kind;
      // final matchesVariety = variety == null || animal.animalVariety == variety;
      final matchesAge = age == null || petKnwoledge.pkPetAge.toString() == age;
      final matchesWeight =
          weight == null || petKnwoledge.pkPetWeight.toString() == weight;
      // return matchesKind && matchesVariety && matchesShelter && matchesSex;
      return matchesKind && matchesAge && matchesWeight;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    setState(() {
      filteredArticle = filterArticle(
        article,
        kind: filters['kind'],
        // variety: filters['variety'],
        age: filters['age'],
        weight: filters['weight'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("寵物知識"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          FilterField(
            filterPage: const PetKnowledgeFilterPage(),
            onFilterApplied: applyFilters,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: loadData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredArticle.length,
                          itemBuilder: (context, index) {
                            return PetKnowledgeListItem(
                              petKnowledge: filteredArticle[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 0),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
