import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/quran_cubit.dart';

class BuildHizbQuarter extends StatelessWidget {
  const BuildHizbQuarter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        List<QuranModel> quranList = cubit.quranData;

        final hizbQuarterNames = cubit.getHizbQuarterNames();

        return ConditionalBuilder(
          condition: quranList.isNotEmpty,
          builder: (BuildContext context) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: hizbQuarterNames.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> hizbQuarterData = cubit.getHizbQuarterStartingPageAndAyah(index + 1, quranList);
                      int startingPage = hizbQuarterData['startingPage'];
                      AyahModel? startingAyah = hizbQuarterData['startingAyah'];

                      return ListTile(
                        title: Text(
                          hizbQuarterNames[index],
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
                          if (startingPage != 0) {
                            Navigator.pushNamed(
                              context,
                              Routes.quranRoute,
                              arguments: {
                                'quranList': quranList,
                                'pageNo': startingPage,
                              },
                            );
                          }
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
}