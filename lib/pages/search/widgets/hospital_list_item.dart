import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/place.dart';
import 'package:pet_app/pages/search/place_detail.dart';
import 'package:pet_app/utils/launcher_utils.dart';

class HospitalItem extends StatefulWidget {
  final Place hospital;
  final int tabIndex;
  const HospitalItem({
    super.key,
    required this.hospital,
    required this.tabIndex,
  });

  @override
  State<HospitalItem> createState() => _HospitalItemState();
}

class _HospitalItemState extends State<HospitalItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Card(
        color: UiColor.textinputColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) => PlaceDetailPage(
                  place: widget.hospital,
                  tabIndex: widget.tabIndex,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.hospital.displayName.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: UiColor.text1Color,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // LauncherUtils.openMap(
                        //   widget.hospital.location.latitude,
                        //   widget.hospital.location.longitude,
                        // );
                        LauncherUtils.openUrl(widget.hospital.googleMapsUri);
                      },
                      icon: SvgPicture.asset(AssetsImages.mapSvg),
                    )
                  ],
                ),
                Text(
                  widget.hospital.formattedAddress,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: UiColor.text2Color,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.hospital.nationalPhoneNumber,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: UiColor.text2Color,
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.hospital.rating != null)
                          SvgPicture.asset(AssetsImages.starSvg),
                        Text(
                          ' ${widget.hospital.rating!.toStringAsFixed(1)} ',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: UiColor.theme2Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
