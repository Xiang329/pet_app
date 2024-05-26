import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class PetKnowledgeDetailPage extends StatefulWidget {
  const PetKnowledgeDetailPage({super.key});

  @override
  State<PetKnowledgeDetailPage> createState() => _PetKnowledgeDetailPageState();
}

class _PetKnowledgeDetailPageState extends State<PetKnowledgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("內容"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "你知道嗎？毛孩也有花粉症！",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: UiColor.text1_color,
                ),
              ),
              SizedBox(height: 30),
              Text(
                """毛孩也跟人一樣？在百花紛飛的春夏時節，會因為本身體質對花粉及特定樹木：如松、樺、橡、杉、楓樹等產生過敏反應。
        
        動物花粉症症狀跟人很相似，會有全身搔癢、眼淚增多或咳嗽打噴嚏等，只是毛孩嗅覺及感受力比人類更敏感，嚴重時還會出現呼吸困難、哮喘，對寶貝們來說可是相當難受的。
        
        由於是體質關係造成，只要出現症狀後，就很難完全根除，醫生建議以降低致敏的因素為主：
        1.減少外出時間
        2.室內外環境清潔
        3.多幫毛孩梳毛、洗澡
        4.搭配醫生指示服用藥物
        
        一起住的家人配合做清潔也很重要，可以從回家先更衣、洗手等方式做起，減少毛孩吸入我們身上花粉的機會！""",
                style: TextStyle(
                  fontSize: 15,
                  color: UiColor.text1_color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
