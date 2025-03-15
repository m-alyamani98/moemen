import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moemen/presentation/bottom_bar/screens/quran/cubit/build_juz.dart';
import 'package:moemen/presentation/bottom_bar/screens/quran/cubit/build_surah.dart';
import '../../../../../app/resources/resources.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          elevation: 0,
          bottom: TabBar(
            indicator:const  UnderlineTabIndicator(
              borderSide: BorderSide(
                color: ColorManager.primary,
                width: 3.0,
              ),
            ),
            labelColor: ColorManager.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: AppStrings.surahName.tr(),
              ),
              Tab(
                text: AppStrings.juz.tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BuildSurah(),
            BuildJuz(),
          ],
        ),
      ),
    );
  }
}