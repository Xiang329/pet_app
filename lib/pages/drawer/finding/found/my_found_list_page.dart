import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/pages/drawer/finding/found/widgets/found_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class MyFoundListPage extends StatefulWidget {
  const MyFoundListPage({super.key});

  @override
  State<MyFoundListPage> createState() => _MyFoundListPageState();
}

class _MyFoundListPageState extends State<MyFoundListPage>
    with AutomaticKeepAliveClientMixin {
  // 保持頁面狀態，防止刷新
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<AppProvider, List<Finding>>(
      selector: (context, appProvider) => appProvider.myFoundsList,
      shouldRebuild: (previous, next) => listEquals(previous, next),
      builder: (context, myFoundsList, child) {
        if (myFoundsList.isEmpty) {
          return const Center(child: EmptyData());
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: myFoundsList.length,
          itemBuilder: (context, index) {
            return FoundListItem(
              finding: myFoundsList[index],
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
