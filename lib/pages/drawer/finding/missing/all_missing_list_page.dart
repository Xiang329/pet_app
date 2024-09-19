import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/finding/missing/widgets/missing_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/no_results.dart';
import 'package:provider/provider.dart';

class AllMissingListPage extends StatefulWidget {
  final List<(Finding, Pet)> missingList;
  final List<(Finding, Pet)> filteredMissingList;
  final bool isFiltering;
  const AllMissingListPage({
    super.key,
    required this.missingList,
    required this.filteredMissingList,
    required this.isFiltering,
  });

  @override
  State<AllMissingListPage> createState() => _AllMissingListPageState();
}

class _AllMissingListPageState extends State<AllMissingListPage>
    with AutomaticKeepAliveClientMixin {
  late bool isFiltering;

  // 保持頁面狀態，防止刷新
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isFiltering = widget.isFiltering;
    return Selector<AppProvider, List<(Finding, Pet)>>(
      selector: (context, appProvider) => appProvider.allMissingsList,
      shouldRebuild: (previous, next) => listEquals(previous, next),
      builder: (context, allMissingsList, child) {
        widget.missingList.clear();
        widget.missingList.addAll(List.from(allMissingsList));
        if (!isFiltering) {
          widget.filteredMissingList.clear();
          widget.filteredMissingList.addAll(List.from(allMissingsList));
        }
        if (isFiltering && widget.filteredMissingList.isEmpty) {
          return const Center(child: NoResults());
        }
        if (widget.filteredMissingList.isEmpty) {
          return const Center(child: EmptyData());
        }
        isFiltering = false;
        return ListView.separated(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: widget.filteredMissingList.length,
          itemBuilder: (context, index) {
            return MissingListItem(
              finding: widget.filteredMissingList[index].$1,
              pet: widget.filteredMissingList[index].$2,
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
