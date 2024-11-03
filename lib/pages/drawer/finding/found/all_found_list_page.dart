import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/pages/drawer/finding/found/widgets/found_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/no_results.dart';
import 'package:provider/provider.dart';

class AllFoundListPage extends StatefulWidget {
  final List<Finding> foundList;
  final List<Finding> filteredFoundList;
  final bool isFiltering;
  const AllFoundListPage({
    super.key,
    required this.foundList,
    required this.filteredFoundList,
    required this.isFiltering,
  });

  @override
  State<AllFoundListPage> createState() => _AllFoundListPageState();
}

class _AllFoundListPageState extends State<AllFoundListPage>
    with AutomaticKeepAliveClientMixin {
  late bool isFiltering;

  // 保持頁面狀態，防止刷新
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isFiltering = widget.isFiltering;
    return Selector<AppProvider, List<Finding>>(
      selector: (context, appProvider) => appProvider.allFoundsList,
      shouldRebuild: (previous, next) => listEquals(previous, next),
      builder: (context, allFoundsList, child) {
        widget.foundList.clear();
        widget.foundList.addAll(List.from(allFoundsList));
        if (!isFiltering) {
          widget.filteredFoundList.clear();
          widget.filteredFoundList.addAll(List.from(allFoundsList));
        }
        if (isFiltering && widget.filteredFoundList.isEmpty) {
          return const Center(child: NoResults());
        }
        if (widget.filteredFoundList.isEmpty) {
          return const Center(child: EmptyData());
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: widget.filteredFoundList.length,
          itemBuilder: (context, index) {
            return FoundListItem(
              finding: widget.filteredFoundList[index],
              editable: false,
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 0),
        );
      },
    );
  }
}
