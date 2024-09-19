import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/socail/widgets/post_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  late Future fetchMySocialMedias;

  @override
  void initState() {
    super.initState();
    fetchMySocialMedias =
        Provider.of<AppProvider>(context, listen: false).fetchMySocialMedias();
  }

  @override
  Widget build(BuildContext context) {
    final mySocialMedias = Provider.of<AppProvider>(context).mySocialMediasList;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("我的貼文"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: FutureBuilder(
          future: fetchMySocialMedias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (mySocialMedias.isEmpty) {
              return const Center(
                  child: EmptyData(
                text: '尚無貼文',
              ));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mySocialMedias.length,
                    itemBuilder: (context, index) {
                      return PostItem(
                        socialMedia: mySocialMedias[index],
                        editable: true,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        thickness: 0,
                        color: UiColor.navigationBarColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
