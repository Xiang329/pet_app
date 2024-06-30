import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/dropdown_list.dart';

class AdoptionFilterPage extends StatefulWidget {
  const AdoptionFilterPage({super.key});

  @override
  State<AdoptionFilterPage> createState() => _AdoptionFilterPageState();
}

class _AdoptionFilterPageState extends State<AdoptionFilterPage> {
  final List<String> petCategory = [
    '狗',
    '貓',
    '鼠',
  ];
  Map<String, List<String>> petBreed = {
    "狗": [
      "混種犬",
      "拉不拉多貴賓犬",
      "貴賓犬",
      "瑪爾貴賓混種犬",
      "瑪爾濟斯犬",
      "博美犬",
      "狐狸博美",
      "柴犬",
      "臘腸犬",
      "長毛臘腸",
      "吉娃娃犬",
      "長毛吉娃娃",
      "台灣犬",
      "約克夏",
      "西施犬",
      "迷你雪納瑞",
      "大型雪納瑞",
      "黃金獵犬",
      "雪納瑞",
      "米格魯犬",
      "拉不拉多犬",
      "哈士奇(西伯利亞雪橇犬)",
      "法國鬥牛犬",
      "威爾斯柯基犬",
      "日本狐狸犬",
      "鬥牛犬(英國)",
      "德國狼犬(德國牧羊犬)",
      "喜樂蒂牧羊犬",
      "比熊犬",
      "英國古代牧羊犬",
      "邊境牧羊犬",
      "哈瓦那犬",
      "可卡獵犬",
      "可卡犬(美系)",
      "澳洲牧羊犬",
      "可卡犬(英系)",
      "比利時牧羊犬(格羅安達/馬利諾/坦比連)",
      "迷你品(迷你杜賓)",
      "可麗牧羊犬(蘇格蘭牧羊犬)",
      "中亞牧羊犬",
      "巴哥犬",
      "馬瑞馬牧羊犬",
      "加泰隆尼亞牧羊犬",
      "迷你美國牧羊犬",
      "邊境梗",
      "白毛(瑞士)牧羊犬",
      "德國剛毛指示犬",
      "秋田犬",
      "美系秋田犬",
      "鬆獅犬",
      "西高地白梗",
      "大麥町",
      "諾福克梗犬",
      "北京犬",
      "獒犬",
      "杜賓犬",
      "洛威納犬(羅威那犬)",
      "傑克羅素梗",
      "拉薩犬",
      "日本狆",
      "蝴蝶犬",
      "牛頭梗",
      "波士頓梗",
      "沙皮犬",
      "英國獵狐犬",
      "獵狐梗",
      "史必茲(史畢諾犬)",
      "阿茲卡爾",
      "巴吉度犬",
      "高山犬",
      "騎士比熊",
      "喜樂蒂柯基",
      "奧斯卡貴賓犬",
      "黃金貴賓犬",
      "查理士犬",
      "美國惡霸犬",
      "標準貴賓犬",
      "迷你貴賓犬",
      "惠比特犬",
      "玩具貴賓犬",
      "拳師犬",
      "大白熊(庇里牛斯山犬)",
      "大丹狗",
      "薩摩耶犬",
      "伯恩山犬",
      "蘇格蘭梗",
      "阿富汗獵犬",
      "波音達指示犬(英系)",
      "靈提",
      "阿拉斯加雪橇犬",
      "高加索犬",
      "西藏獒犬",
      "騎士查理王獵犬",
      "馬士提夫犬",
      "聖伯納犬",
      "鬥牛獒犬",
      "萬能梗",
      "澳洲(絲毛)梗",
      "紐波利頓犬(拿波里獒犬)",
      "中國冠毛犬",
      "愛斯基摩犬",
      "日本土佐犬",
      "甲斐犬",
      "紀州犬",
      "灰狗(靈提)",
      "紐芬蘭犬",
      "西藏梗",
      "波利犬",
      "阿根廷杜告犬",
      "貝生吉犬",
      "貝靈頓梗",
      "波爾多獒犬",
      "小型獅子犬",
      "斯塔福郡鬥牛梗",
      "四國犬",
      "史賓格犬(激飛犬)",
      "伯瑞犬",
      "義大利獒犬",
      "巴西菲勒犬",
      "威瑪獵犬",
      "泰國脊背犬(泰皇犬)",
      "羅得西亞背脊犬",
      "剛毛獵狐梗(懷亞鐵利亞)",
      "尋血獵犬",
      "普羅特獵犬",
      "雪達犬",
      "班道戈犬",
      "湖畔梗",
      "黑褐色獵浣熊犬",
      "藍斑獵犬(大藍加斯科涅獵犬)",
      "葡萄牙水犬",
      "土耳其坎高犬",
      "格林芬犬",
      "維茲拉(匈牙利獵犬-指示犬)",
      "俄羅斯黑梗",
      "波索獵犬(蘇俄牧羊/獵狼犬)",
      "愛爾蘭獵狼犬",
      "西里漢梗",
      "棉花面紗犬",
      "平毛尋回(獵)犬",
      "捷克狼犬",
      "史奇派克犬",
      "義大利卡斯羅犬",
      "比特犬之混種犬",
      "日本土佐犬之混種犬",
      "紐波利頓犬之混種犬",
      "阿根廷杜告犬之混種犬",
      "巴西菲勒犬之混種犬",
      "獒犬之混種犬",
      "庇里牛斯牧羊犬",
      "鬥牛犬之混種犬",
      "迦南犬",
      "小型狐狸犬",
      "喜樂蒂狐狸犬",
      "波柴",
      "加納利犬",
      "卡斯羅",
      "比利時狼犬",
      "北海道犬",
      "迷你牛頭梗",
      "鬥牛犬(西班牙)",
      "保沙瓦獵犬",
      "卡塔胡拉豹犬",
      "芬蘭狐狸犬",
      "布拉格瑟瑞克犬",
      "凱利藍梗犬",
      "波洛尼亞犬",
      "斯皮茨犬",
      "牧羊貴賓",
      "凱恩犬",
      "俄歐萊卡犬",
      "珍島犬"
    ],
    "貓": [
      "混種貓",
      "喜馬拉雅貓(短毛)",
      "混種長毛貓",
      "科拉特",
      "巴比諾貓",
      "異國短毛貓(加菲貓)",
      "美國短毛貓",
      "美國長毛貓",
      "孟加拉豹貓",
      "波斯貓",
      "曼赤肯貓",
      "非標準型曼赤肯(長腿)",
      "英國短毛貓",
      "英國長毛貓",
      "金吉拉",
      "金吉拉(短毛)",
      "蘇格蘭折耳貓",
      "布偶貓",
      "俄羅斯藍貓",
      "沙特爾貓(法國藍貓)",
      "喜瑪拉雅貓",
      "挪威森林貓",
      "暹羅貓",
      "小步舞曲(拿破崙短腿貓)",
      "非標準型小步舞曲",
      "美國捲耳貓",
      "緬因貓",
      "阿比西尼亞貓",
      "蘇格蘭貓(立耳)",
      "伯曼貓",
      "安哥拉貓(土耳其)",
      "曼島貓",
      "拉邦捲毛貓",
      "拉邦直毛貓",
      "得文捲毛貓",
      "塞爾凱克捲毛貓",
      "美國硬毛貓",
      "柯尼斯捲毛貓",
      "緬甸貓",
      "加拿大無毛貓(芬克斯貓)",
      "日本截尾貓",
      "加州閃亮貓",
      "波米拉貓",
      "索馬利貓(長毛阿比西尼亞)",
      "孟買貓",
      "熱帶草原貓(薩凡納貓)",
      "埃及貓",
      "西伯利亞(森林)貓",
      "雪鞋貓",
      "奧西貓",
      "歐斯亞史烈斯貓",
      "東奇尼貓",
      "異國長毛貓(加菲貓)",
      "狼貓",
      "玩具虎貓",
      "潘提拉彪貓",
      "峇里貓",
      "布偶貓(短毛)",
      "塞爾特直毛貓",
      "布偶貓(長毛)",
      "賓士貓",
      "折耳貓",
      "羊毛貓",
      "韓國短毛貓",
      "東方短毛貓",
      "歐洲短毛貓",
      "巴厘貓",
      "狸花貓",
      "新加坡貓(獅城貓)"
    ],
    "鼠": ["薯條", "薯餅", "勞薯"],
  };

  final List<String> shelter = [
    "新北市政府動物保護防疫處",
    "新北市新店區公立動物之家",
    "新北市板橋區公立動物之家",
    "新北市中和區公立動物之家",
    "新北市淡水區公立動物之家",
    "新北市瑞芳區公立動物之家",
    "新北市五股區公立動物之家",
    "新北市八里區公立動物之家",
    "新北市三芝區公立動物之家",
    "宜蘭縣流浪動物中途之家",
    "桃園市動物保護教育園區",
    "新竹縣動物保護教育園區",
    "苗栗縣動物保護教育園區",
    "臺中市動物之家南屯園區",
    "臺中市動物之家后里園區",
    "彰化縣流浪狗中途之家",
    "南投縣公立動物收容所",
    "雲林縣流浪動物收容所",
    "嘉義縣動物保護教育園區",
    "高雄市壽山動物保護教育園區",
    "高雄市燕巢動物保護關愛園區",
    "屏東縣公立犬貓中途之家",
    "屏東縣動物之家",
    "臺東縣動物收容中心",
    "花蓮縣狗貓躍動園區",
    "澎湖縣流浪動物收容中心",
    "基隆市寵物銀行",
    "新竹市動物保護教育園區",
    "嘉義市動物保護教育園區",
    "臺南市動物之家灣裡站",
    "臺南市動物之家善化站",
    "臺北市動物之家",
    "連江縣流浪犬收容中心",
    "金門縣動物收容中心"
  ];

  final List<String> petGender = [
    '公',
    '母',
  ];

  String? selectedPetCategory;
  String? selectedPetBreed;
  String? selectedShelter;
  String? selectedPetGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("篩選"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownList(
                // width: constraints.maxWidth,
                title: "類別",
                items: petCategory,
                value: selectedPetCategory,
                onChanged: (String? value) {
                  setState(() {
                    if (selectedPetCategory != value) {
                      // 需清空否則報錯
                      selectedPetBreed = null;
                      selectedPetCategory = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: "品種",
                items: petBreed[selectedPetCategory] ?? [],
                value: selectedPetBreed,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetBreed = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: "收容所",
                items: shelter,
                value: selectedShelter,
                onChanged: (String? value) {
                  setState(() {
                    selectedShelter = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: "性別",
                items: petGender,
                value: selectedPetGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetGender = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: UiColor.theme2_color),
                  child: const Text(
                    '確定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Map<String, String> selectedFilters = {
                      'kind': selectedPetCategory ?? '',
                      'variety': selectedPetBreed ?? '',
                      'shelter': selectedShelter ?? '',
                      'sex': selectedPetGender ?? '',
                    };
                    selectedFilters.removeWhere((key, value) => value.isEmpty);
                    print(selectedFilters);
                    Navigator.of(context, rootNavigator: true)
                        .pop(selectedFilters);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
