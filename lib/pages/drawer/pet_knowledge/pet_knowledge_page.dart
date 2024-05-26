import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_filter_page.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/widgets/pet_knowledge_list_item.dart';
import 'package:pet_app/widgets/filter_field.dart';

class PetKnowledgePage extends StatefulWidget {
  const PetKnowledgePage({super.key});

  @override
  State<PetKnowledgePage> createState() => _PetKnowledgePageState();
}

class _PetKnowledgePageState extends State<PetKnowledgePage> {
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
          const FilterField(
            filterPage: PetKnowledgeFilterPage(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return const PetKnowledgeListItem();
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
