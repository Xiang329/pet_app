import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/pet_knowledge.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_filter_page.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/widgets/pet_knowledge_list_item.dart';
import 'package:pet_app/services/pet_knowledges_service.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:pet_app/widgets/no_results.dart';

class PetKnowledgePage extends StatefulWidget {
  const PetKnowledgePage({super.key});

  @override
  State<PetKnowledgePage> createState() => _PetKnowledgePageState();
}

class _PetKnowledgePageState extends State<PetKnowledgePage> {
  List<PetKnowledge> article = [];
  List<PetKnowledge> filteredArticle = [];
  late Future loadData;
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    loadData = loadPetKnowledgesData();
  }

  Future loadPetKnowledgesData() async {
    article = await PetKnowledgesService.getPetKnowledges().catchError((e) {
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
    filteredArticle = article;
  }

  List<PetKnowledge> filterArticle(List<PetKnowledge> article,
      {String? petClass, String? petVariety, String? age, String? weight}) {
    return article.where((petKnwoledge) {
      final matchesClass =
          petClass == null || petKnwoledge.className == petClass;
      final matchesVariety =
          petVariety == null || petKnwoledge.varietyName == petVariety;
      return matchesClass && matchesVariety;
    }).toList();
  }

  void applyFilters(Map<String, String> filters) {
    isFiltering = true;
    setState(() {
      filteredArticle = filterArticle(
        article,
        petClass: filters['class'],
        petVariety: filters['variety'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("寵物知識"),
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
            filterPage: const PetKnowledgeFilterPage(),
            onFilterApplied: applyFilters,
            maxHeight: 2,
          ),
          Expanded(
            child: FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (isFiltering && filteredArticle.isEmpty) {
                    return const Center(child: NoResults());
                  }
                }
                if (filteredArticle.isEmpty) {
                  return const Center(child: EmptyData());
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
