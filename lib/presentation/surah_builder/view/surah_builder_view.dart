import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/utils/functions.dart';
import '../../../domain/models/quran/quran_model.dart';
import '../../components/separator.dart';
import '../../bottom_bar/cubit/bottom_bar_cubit.dart';
import '../../bottom_bar/screens/quran/cubit/quran_cubit.dart';
import '../../../../../app/resources/resources.dart';


class SurahBuilderView extends StatefulWidget {
  final List<QuranModel> quranList;
  final int pageNo;

  const SurahBuilderView({
    Key? key,
    required this.quranList,
    required this.pageNo,
  }) : super(key: key);

  @override
  _SurahBuilderViewState createState() => _SurahBuilderViewState();
}

class _SurahBuilderViewState extends State<SurahBuilderView> {
  bool isTitleVisible = true; // Initialize directly
  late PageController pageController;
  Color _backgroundColor = Colors.white;
  Color _imageColor = Colors.black;


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageNo - 1);
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    HomeCubit homeCubit = HomeCubit.get(context);
    final currentLocale = context.locale;
    Color? selectedColor;
    bool isEnglish = currentLocale.languageCode == LanguageType.english.getValue();
    double currentPage = widget.pageNo.toDouble();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            isTitleVisible = !isTitleVisible;
          });
        },
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                reverse: isEnglish,
                controller: pageController,
                itemCount: 604,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index + 1;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  var quranPageNumber = index + 1;
                  final List<QuranModel> pageSurahsList =
                  cubit.getPageSurahs(quran: widget.quranList, pageNo: quranPageNumber);
                  final List<String> pageSurahsNamesList =
                  List.of(pageSurahsList.map((surah) => surah.name));

                  final String surahNameOnScreen = pageSurahsNamesList.first;
                  final List<AyahModel> ayahs = cubit.getAyahsFromPageNo(
                      quranList: widget.quranList, pageNo: quranPageNumber);

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: _backgroundColor,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Image.asset(
                            "assets/images/quran/page${getQuranImageNumberFromPageNumber(quranPageNumber)}.png",
                            color: _imageColor,
                            colorBlendMode: BlendMode.srcIn,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isTitleVisible)
                        Column(
                          children: [
                            Container(
                              color: ColorManager.black.withOpacity(0.7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          homeCubit.bookMarkPage(currentPage.toInt());
                                        },
                                        icon: Icon(
                                          homeCubit.isPageBookMarked(currentPage.toInt())
                                              ? Icons.bookmark
                                              : Icons.bookmark_add_outlined,
                                          color: ColorManager.white,
                                        ),
                                      ),
                                      PopupMenuButton<Color>(
                                        icon: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                        ),
                                        onSelected: (Color newColor) {
                                          setState(() {
                                            _backgroundColor = newColor;
                                            if (newColor == Colors.black) {
                                              _imageColor = Colors.white;
                                            } else {
                                              _imageColor = Colors.black;
                                            }
                                          });
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<Color>>[
                                          PopupMenuItem<Color>(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(context, Colors.black),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(context, ColorManager.accentPrimary),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: ColorManager.accentPrimary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(context, ColorManager.backgroundQuran),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.black, width: 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            surahNameOnScreen,
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              wordSpacing: AppSize.s5.w,
                                              letterSpacing: AppSize.s0_1.w,
                                              fontFamily: FontConstants.meQuranFontFamily,
                                              color: ColorManager.white,
                                            ),
                                          ),
                                          Text(
                                            "${AppStrings.juz.tr()}: ${ayahs.first.juz.toString().tr()}، ${AppStrings.hizb.tr()}: ${((ayahs.first.hizbQuarter / 4).ceil()).toString().tr()} ",
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              fontFamily: FontConstants.uthmanTNFontFamily,
                                              color: ColorManager.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'assets/images/logoico.svg',
                                          width: AppSize.s35.r,
                                          height: AppSize.s35.r,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
                                        icon: Icon(FluentIcons.chevron_left_48_regular, color: ColorManager.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            getSeparator(context),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: AppPadding.p8.h),
                              child: Text(
                                (quranPageNumber).toString().tr(),
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: FontConstants.uthmanTNFontFamily,
                                  height: AppSize.s1.h,
                                  color: Theme.of(context).unselectedWidgetColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (isTitleVisible)
              Slider(
                value: currentPage,
                min: 1,
                max: 604,
                divisions: 603,
                activeColor:ColorManager.primary,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                  pageController.jumpToPage((value - 1).toInt());
                },
              ),
          ],
        ),
      ),
    );
  }
}