import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/models/animal.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_detail.dart';
import 'package:pet_app/widgets/divider_row.dart';

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
            color: UiColor.textinput_color,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
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
                    DividerRow(
                      children: [
                        Text(
                          widget.animal.animalKind,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1_color,
                          ),
                        ),
                        Text(
                          widget.animal.animalVariety,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1_color,
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: UiColor.text2_color,
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
                        color: UiColor.text2_color,
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
