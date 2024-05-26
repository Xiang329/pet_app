import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/widgets/dialog/add_admin_dialog.dart';
import 'package:pet_app/pages/home/widgets/dialog/invite_code_generator.dart';
import 'package:pet_app/widgets/divider_row.dart';
import 'package:pet_app/pages/home/widgets/pet_admin_list_item.dart';
import 'package:pet_app/providers/pet_admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessControlPage extends StatefulWidget {
  const AccessControlPage({super.key});

  @override
  State<AccessControlPage> createState() => _AccessControlPageState();
}

class _AccessControlPageState extends State<AccessControlPage> {
  @override
  Widget build(BuildContext context) {
    print("進入權限控制面板");
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("權限"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: UiColor.text1_color,
              ),
              onPressed: () async {
                int? result = await showDialog(
                  context: context,
                  builder: (context) {
                    return const AddAdminDialog();
                  },
                );
                if (!context.mounted) return;
                if (result != null) {
                  if (result == 1) print('選擇僅查看');
                  if (result == 2) print('選擇查看及編輯');
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return const InviteCodeGeneratorDialog();
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
              child: Card(
                color: UiColor.textinput_color,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(AssetsImages.dogJpg),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DividerRow(
                              children: [
                                Text('Angelina',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: UiColor.text1_color)),
                                Text("主要管理人",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500,
                                        color: UiColor.text1_color)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Text(
                  "共同管理人",
                  style: TextStyle(
                      color: UiColor.text1_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Consumer<PetAdminsProvider>(
              builder: (context, provider, _) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.petAdmins.length,
                  itemBuilder: (context, index) {
                    return PetAdminItem(
                      admin: provider.petAdmins[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
