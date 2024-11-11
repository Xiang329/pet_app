import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/place.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/search/place_detail.dart';
import 'package:pet_app/utils/launcher_utils.dart';

class ShopItem extends StatefulWidget {
  final Place shop;
  final int tabIndex;
  const ShopItem({
    super.key,
    required this.shop,
    required this.tabIndex,
  });

  @override
  State<ShopItem> createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
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
                  place: widget.shop,
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
                        widget.shop.displayName.text,
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
                        LauncherUtils.openUrl(widget.shop.googleMapsUri);
                      },
                      icon: SvgPicture.asset(AssetsImages.mapSvg),
                    )
                  ],
                ),
                Text(
                  widget.shop.formattedAddress,
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
                      widget.shop.nationalPhoneNumber ?? '店家未提供',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: UiColor.text2Color,
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.shop.rating != null)
                          SvgPicture.asset(AssetsImages.starSvg),
                        Text(
                          ' ${widget.shop.rating?.toStringAsFixed(1)} ',
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
