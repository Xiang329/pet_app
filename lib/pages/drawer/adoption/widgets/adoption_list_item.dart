import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/animal.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_detail.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';

class AdoptionListItem extends StatefulWidget {
  final Animal animal;
  const AdoptionListItem({super.key, required this.animal});

  @override
  State<AdoptionListItem> createState() => _AdoptionListItemState();
}

class _AdoptionListItemState extends State<AdoptionListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 120,
          child: Card(
            color: UiColor.textinputColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AdoptionDetailPage(
                      animal: widget.animal,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichTextDivider(
                      children: [
                        TextSpan(
                          text: widget.animal.animalKind,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1Color,
                          ),
                        ),
                        TextSpan(
                          text: widget.animal.animalVariety,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1Color,
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: UiColor.text2Color,
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "性別　",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.animal.animalSex,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: UiColor.text2Color,
                      ),
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "收容所　",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.animal.shelterName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
