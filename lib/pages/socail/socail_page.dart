import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/socail/add_post_page.dart';
import 'package:pet_app/pages/socail/my_post_page.dart';
import 'package:pet_app/pages/socail/widgets/post_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late Future fetchAllSocialMedias;

  @override
  void initState() {
    super.initState();
    fetchAllSocialMedias =
        Provider.of<AppProvider>(context, listen: false).fetchAllSocialMedias();
  }

  @override
  Widget build(BuildContext context) {
    final allSocialMedias =
        Provider.of<AppProvider>(context).allSocialMediasList;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("社群"),
        actions: [
          SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) => const MyPostPage(),
                  ),
                );
              },
              icon: SvgPicture.asset(AssetsImages.articleSvg),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: FutureBuilder(
            future: fetchAllSocialMedias,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (allSocialMedias.isEmpty) {
                return const Center(
                    child: EmptyData(
                  text: '尚無貼文',
                ));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: allSocialMedias.length,
                      itemBuilder: (context, index) {
                        return PostItem(
                          socialMedia: allSocialMedias[index],
                          editable: false,
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
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FutureBuilder(
        future: fetchAllSocialMedias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const SizedBox();
            }
            return FloatingActionButton(
              backgroundColor: UiColor.theme2Color,
              shape: const CircleBorder(),
              onPressed: () async {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AddPostPage(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
