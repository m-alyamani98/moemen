import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momen/domain/models/quran/quran_model.dart';
import 'package:momen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:momen/presentation/bottom_bar/screens/settings/service/daily_alert.dart';
import 'package:momen/presentation/components/widget.dart';
import 'package:momen/presentation/pay_builder/payment.dart';
import 'package:momen/presentation/surah_builder/view/surah_builder_view.dart';
import 'package:momen/presentation/werd_builder/new_khetma.dart';
import 'package:momen/presentation/werd_builder/previos_werd.dart';

import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';

import '../../../cubit/bottom_bar_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        QuranCubit cubit = QuranCubit.get(context);
        List<QuranModel> quranList = cubit.quranData;
        return Padding(
          padding: EdgeInsets.only(top: AppPadding.p18.h),
          child: ListView(
            children: [
              getTitle(settingName: AppStrings.support.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.heart_48_filled,
                settingName: AppStrings.supportUs.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportAppPage(), // Replace with the page you want to navigate to
                    ),
                  );
                },
                context: context,
                color: Colors.redAccent,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.currentKhetma.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_right_48_regular,
                settingName: AppStrings.previousWerd.tr(),
                trailing: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '20',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_left_48_regular,
                settingName: AppStrings.nextWerd.tr(),
                trailing: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '20',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.bookmark_32_regular,
                settingName: AppStrings.quranSeparator.tr(),
                trailing: const SizedBox(),
                onTap: () async {
                  final cubit = HomeCubit.get(context);
                  final bookMarkedPage = cubit.getBookMarkPage();
                  if (bookMarkedPage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahBuilderView(quranList: quranList, pageNo: bookMarkedPage),
                      ),
                    );
                  }
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0.3,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.quranSonan.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_right_48_regular,
                settingName: AppStrings.soratAlkahf.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  final QuranCubit cubit = QuranCubit.get(context);
                  final surahAlKahf = cubit.quranData.firstWhere(
                        (surah) => surah.name == "الكهف" || surah.englishName == "Al-Kahf",
                  );

                  Navigator.pushNamed(
                    context,
                    Routes.quranRoute,
                    arguments: {
                      'quranList': cubit.quranData,
                      'pageNo': surahAlKahf.ayahs[0].page,
                    },
                  );
                                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_left_48_regular,
                settingName: AppStrings.soratAlMolk.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  final QuranCubit cubit = QuranCubit.get(context);
                  final surahAlMulk = cubit.quranData.firstWhere(
                        (surah) => surah.name == "الملك" || surah.englishName == "Al-Mulk",
                  );

                  Navigator.pushNamed(
                    context,
                    Routes.quranRoute,
                    arguments: {
                      'quranList': cubit.quranData,
                      'pageNo': surahAlMulk.ayahs[0].page, // Use the first Ayah's page
                    },
                  );
                  },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_right_48_regular,
                settingName: AppStrings.soratAlBaqarah.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  final QuranCubit cubit = QuranCubit.get(context);
                  final surahAlBaqara = cubit.quranData.firstWhere(
                        (surah) => surah.name == "البقرة" || surah.englishName == "Al-Baqara",
                  );

                  Navigator.pushNamed(
                    context,
                    Routes.quranRoute,
                    arguments: {
                      'quranList': cubit.quranData,
                      'pageNo': surahAlBaqara.ayahs[0].page,
                    },
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(settingName: AppStrings.setting.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.alert_48_filled,
                settingName: AppStrings.dailyAlarm.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyAlert(), // Replace with the page you want to navigate to
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.add_circle_48_regular,
                settingName: AppStrings.newKhetma.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewKhetmaPage(), // Replace with the page you want to navigate to
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.prayerTime.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.alert_48_filled,
                settingName: AppStrings.settingPrayerTime.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: 'assets/images/kaaba.svg',
                icon: null,
                settingName: AppStrings.qiblaDirection.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.adhkarAlarm.tr(), context: context),
              SwitchTileWidget(
                icon: FluentIcons.weather_sunny_48_regular,
                settingName: AppStrings.adhkarMorningAlarm.tr(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
                isSwitched: true,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.adhkarMorningTime.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              SwitchTileWidget(
                icon: FluentIcons.weather_moon_48_regular,
                settingName: AppStrings.adhkarEveningAlarm.tr(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 360,
                isSwitched: true,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.adhkarEveningTime.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.sonanAlarm.tr(), context: context),
              SwitchTileWidget(
                icon: FluentIcons.alert_48_filled,
                settingName: AppStrings.soratAlMolkAlarm.tr(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
                isSwitched: true,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.soratAlMolkTime.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              SwitchTileWidget(
                icon: FluentIcons.alert_48_filled,
                settingName: AppStrings.soratAlBaqarahAlarm.tr(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
                isSwitched: true,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.soratAlBaqarahTime.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.settingApp.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: Icons.language_outlined,
                settingName: AppStrings.changeAppLanguage.tr(),
                trailing: Text(
                  AppStrings.changeAppLanguageIcon.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        height: AppSize.s1_8.h,
                      ),
                ),
                onTap: () {
                  var cubit = HomeCubit.get(context);
                  cubit.changeAppLanguage(context);
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.call_48_filled,
                settingName: AppStrings.callUs.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: 'assets/images/threads.svg',
                icon: null,
                settingName: AppStrings.threads.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: 'assets/images/insta.svg',
                icon: null,
                settingName: AppStrings.instagram.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.share_48_regular,
                settingName: AppStrings.share.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.thumb_like_48_filled,
                settingName: AppStrings.appRating.tr(),
                trailing: const SizedBox(),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
            ],
          ),
        );
      },
    );
  }
}
