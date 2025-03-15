import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moemen/domain/models/quran/juz_model.dart';
import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/quran_cubit.dart';

class BuildJuz extends StatelessWidget {
  const BuildJuz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        List<QuranModel> quranList = cubit.quranData;

        final juzNames = cubit.getJuzNames();

        return ConditionalBuilder(
          condition: quranList.isNotEmpty,
          builder: (BuildContext context) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: juzNames.length,
                    itemBuilder: (context, index) {
                      List<AyahModel> juzAyahs = cubit.getJuzAyahs(index + 1, quranList);
                      int startingPage = juzAyahs.isNotEmpty ? juzAyahs.first.page : 0;
                      return ListTile(
                        title: Text(
                          juzNames[index],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: FontConstants.meQuranFontFamily,
                            wordSpacing: AppSize.s5.w,
                            letterSpacing: AppSize.s0_1.w,
                          ),
                        ),
                        trailing: Text(
                          startingPage != 0
                              ? "   صفحة $startingPage"
                              : "   لا توجد بيانات",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontFamily: FontConstants.uthmanTNFontFamily),
                        ),
                        onTap: () {
                          List<AyahModel> juzAyahs = cubit.getJuzAyahs(index + 1, quranList);

                          int startingPage = juzAyahs.isNotEmpty ? juzAyahs.first.page : 1;

                          Navigator.pushNamed(
                            context,
                            Routes.quranRoute,
                            arguments: {
                              'quranList': quranList,
                              'pageNo': startingPage,
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => getSeparator(context),
                  ),
                ),
              ],
            );
          },
          fallback: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          },
        );
      },
    );
  }


  List<JuzModel> groupAyahsByJuz(List<AyahModel> ayahs) {
    List<JuzModel> juzList = [];

    for (int juzNumber = 1; juzNumber <= 30; juzNumber++) {
      List<AyahModel> juzAyahs = ayahs.where((ayah) => ayah.juz == juzNumber).toList();

      int startingPage = juzAyahs.isNotEmpty ? juzAyahs.first.page : 0;

      if (juzAyahs.isNotEmpty) {
        juzList.add(JuzModel(
          juzNumber: juzNumber,
          startingPage: startingPage,
          ayahs: juzAyahs,
        ));
      }
    }

    return juzList;
  }
}