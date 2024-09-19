import 'package:flutter/widgets.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsImages.noResultsPng),
        const Text(
          '查無結果',
          style: TextStyle(
            color: UiColor.text1Color,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
