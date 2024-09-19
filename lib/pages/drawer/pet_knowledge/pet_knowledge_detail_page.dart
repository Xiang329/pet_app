import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/pet_knowledge.dart';

class PetKnowledgeDetailPage extends StatefulWidget {
  final PetKnowledge petKnowleadge;
  const PetKnowledgeDetailPage({super.key, required this.petKnowleadge});

  @override
  State<PetKnowledgeDetailPage> createState() => _PetKnowledgeDetailPageState();
}

class _PetKnowledgeDetailPageState extends State<PetKnowledgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("內容"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.petKnowleadge.pkTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: UiColor.text1Color,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  widget.petKnowleadge.pkProposalContent,
                  style: const TextStyle(
                    fontSize: 15,
                    color: UiColor.text1Color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
