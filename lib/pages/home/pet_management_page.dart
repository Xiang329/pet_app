import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/pages/home/widgets/dialog/show_invite_code.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pets_service.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';
import 'package:pet_app/pages/home/widgets/pet_management_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetManagementPage extends StatefulWidget {
  final int petId;
  const PetManagementPage({super.key, required this.petId});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final List<PetManagement> coManagers = [];
  late Member mainManager;
  late Pet pet;
  late Future _loadData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData = loadData();
  }

  Future loadData() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      coManagers.clear();
      pet = await PetsService.getPetById(widget.petId);
      for (var element in pet.petManagementList) {
        switch (element.pmPermissions) {
          case '1':
            mainManager = element.member!;
            break;
          case '2':
          case '3':
            coManagers.add(element);
            break;
        }
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('錯誤'),
            content: Text(e.toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberId = Provider.of<AppProvider>(context).memberId;
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("權限"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          FutureBuilder(
            future: _loadData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Container();
                }
                return SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: UiColor.text1Color,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ShowInviteCodeDialog(
                            pet: pet,
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: EmptyData());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: UiColor.textinputColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: mainManager.memberMugShot.isEmpty
                                  ? const AssetImage(AssetsImages.userAvatorPng)
                                  : MemoryImage(mainManager.memberMugShot),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichTextDivider(
                                    children: [
                                      TextSpan(
                                        text: mainManager.memberName,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: UiColor.text1Color),
                                      ),
                                      const TextSpan(
                                        text: "主要管理人",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: UiColor.text1Color),
                                      ),
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
                            color: UiColor.text1Color,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: coManagers.length,
                    itemBuilder: (context, index) {
                      return PetManagementListItem(
                        coManager: coManagers[index],
                        editable: memberId == mainManager.memberId,
                        reloadPage: () async {
                          await loadData();
                          if (!context.mounted) return;
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
