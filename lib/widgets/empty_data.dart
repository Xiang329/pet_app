import 'package:flutter/widgets.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class EmptyData extends StatelessWidget {
  final String text;
  const EmptyData({
    super.key,
    this.text = '沒有資料',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsImages.emptyDataPng),
         Text(
          text,
          style: const TextStyle(
            color: UiColor.text1Color,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
