import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/pet_knowledge.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_detail_page.dart';

class PetKnowledgeListItem extends StatefulWidget {
  final PetKnowledge petKnowledge;
  const PetKnowledgeListItem({super.key, required this.petKnowledge});

  @override
  State<PetKnowledgeListItem> createState() => _PetKnowledgeListItemState();
}

class _PetKnowledgeListItemState extends State<PetKnowledgeListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      // padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 100,
          child: Card(
            color: UiColor.textinputColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PetKnowledgeDetailPage(
                      petKnowleadge: widget.petKnowledge,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.petKnowledge.pkTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text1Color,
                      ),
                    ),
                    Text(
                      widget.petKnowledge.pkProposalContent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: UiColor.text2Color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
