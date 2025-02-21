import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/quran_cubit.dart';

class BuildSurah extends StatelessWidget {
  const BuildSurah({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        List<QuranModel> quranList = cubit.quranData;

        final currentLocale = context.locale;
        bool isEnglish =
            currentLocale.languageCode == LanguageType.english.getValue();

        return ConditionalBuilder(
          condition: quranList.isNotEmpty,
          builder: (BuildContext context) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => _surahsIndexItem(
                      surahId: (index + 1).toString().tr(),
                      surahName: quranList[index].name,
                      englishSurahName: quranList[index].englishName,
                      pageNo: quranList[index].ayahs[0].page,
                      quranList: quranList,
                      isEnglish: isEnglish,
                      context: context,
                    ),
                    separatorBuilder: (context, index) => getSeparator(context),
                    itemCount: quranList.length,
                  ),
                ),
              ],
            );
          },
          fallback: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(color: ColorManager.primary));
          },
        );
      },
    );
  }




  Widget _surahsIndexItem({
    required String surahId,
    required String surahName,
    required String englishSurahName,
    required int pageNo,
    required List<QuranModel> quranList,
    required bool isEnglish,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p5.h),
      child: ListTile(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: AppPadding.p5.h),
          child: Text(
            isEnglish ? englishSurahName : surahName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: FontConstants.meQuranFontFamily,
                wordSpacing: AppSize.s5.w,
                letterSpacing: AppSize.s0_1.w,
                color: ColorManager.textPrimary
            ),
          ),
        ),
        trailing: Text(
          "   صفحة ${pageNo.toString().tr()}",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontFamily: FontConstants.uthmanTNFontFamily,color: ColorManager.textPrimary),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.quranRoute,
            arguments: {
              'quranList': quranList,
              'pageNo': pageNo,
            },
          );
        },
      ),
    );
  }
}