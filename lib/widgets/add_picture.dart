import 'package:flutter/widgets.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class AddPicture extends StatelessWidget {
  final bool visible;
  final GestureTapCallback? onTap;
  const AddPicture({
    super.key,
    required this.visible,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AssetsImages.addPhotoPng),
                  const Positioned(
                    top: 0,
                    child: Text(
                      '點擊新增圖片',
                      style: TextStyle(
                        color: UiColor.text1Color,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
