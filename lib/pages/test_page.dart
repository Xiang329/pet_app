import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/finding/finding_filter_page.dart';
import 'package:pet_app/pages/home/widgets/dialogs_old/invite_code_dialog.dart';
import 'package:pet_app/widgets/custom.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:pet_app/widgets/filled_text_field_2.dart';
import 'package:pet_app/widgets/filter_field.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    // 初始化数据
    _retrieveIcons();
  }

  List<IconData> _icons = []; //保存Icon数据
  Widget _buildBody() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 1.0, //显示区域宽高相等
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        //如果显示到最后一个并且Icon总数小于200时继续获取数据
        print(index);
        if (index == _icons.length - 1 && _icons.length < 20) {
          _retrieveIcons();
        }
        return Icon(_icons[index]);
      },
    );
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }

  Widget _buildCustomWidget() {
    BorderRadius dynamicBorder = const BorderRadius.only(
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    );

    int segmentedControlGroupValue = 0;
    final Map<int, Widget> myTabs = const <int, Widget>{
      0: Text("Item 1"),
      1: Text("Item 2")
    };

    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OutlinedTextField(
              // height: 50,
              labelText: "電子郵件",
              hintText: "hello",
            ),
            const SizedBox(height: 10),
            const FilledTextField(
                // height: 50,
                ),
            const SizedBox(height: 10),
            const FilledTextField2(
                // height: 7,
                ),
            TextButton(
              onPressed: () async {
                // showCustomModalBottomSheet(
                //   context: context,
                //   titleLabel: "標題",
                // );
                // final result = await showDialog(
                //   context: context,
                //   builder: (context) {
                //     // return const AddPetDialog();
                //     return const InviteCodeDialog();
                //   },
                // );

                // if (result != null) {
                //   print(result);
                // }
              },
              child: const Text("顯示"),
            ),
            SizedBox(
              width: 100,
              child: CustomSlidingSegmentedControl<int>(
                // initialValue: 1,
                height: 34,
                isStretch: true,
                innerPadding: const EdgeInsets.all(4.0),
                children: const {
                  1: Text('僅查看',
                      style:
                          TextStyle(fontSize: 13, color: UiColor.text1_color)),
                  2: Text('查看及編輯',
                      style:
                          TextStyle(fontSize: 13, color: UiColor.text1_color)),
                },
                decoration: BoxDecoration(
                  color: UiColor.theme1_color,
                  borderRadius: BorderRadius.circular(30),
                ),
                thumbDecoration: BoxDecoration(
                  color: UiColor.theme2_color,
                  borderRadius: BorderRadius.circular(30),
                ),
                // duration: const Duration(milliseconds: 200),
                // curve: Curves.easeInToLinear,
                onValueChanged: (v) {
                  print(v);
                },
              ),
            ),
            const SizedBox(
              width: 300,
              child: FilterField(
                filterPage: FindingFilterPage(),
                margin: EdgeInsets.all(0),
              ),
            ),
            SizedBox(
                height: 200,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('data'),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('000'),
      ),
      backgroundColor: Colors.blue,
      // body: _buildBody(),
      body: _buildCustomWidget(),
    );
  }
}
