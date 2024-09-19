import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/finding/missing/widgets/missing_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class MyMissingListPage extends StatefulWidget {
  const MyMissingListPage({super.key});

  @override
  State<MyMissingListPage> createState() => _MyMissingListPageState();
}

class _MyMissingListPageState extends State<MyMissingListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持頁面狀態，防止刷新
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<AppProvider, List<(Finding, Pet)>>(
      selector: (context, appProvider) => appProvider.myMissingsList,
      shouldRebuild: (previous, next) => listEquals(previous, next),
      builder: (context, myMissingsList, child) {
        if (myMissingsList.isEmpty) {
          return const Center(child: EmptyData());
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: myMissingsList.length,
          itemBuilder: (context, index) {
            return MissingListItem(
              finding: myMissingsList[index].$1,
              pet: myMissingsList[index].$2,
              editable: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 0),
        );
      },
    );
  }
}
