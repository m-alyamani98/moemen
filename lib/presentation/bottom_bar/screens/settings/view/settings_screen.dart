import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:moemen/domain/models/quran/quran_model.dart';
import 'package:moemen/presentation/bottom_bar/screens/prayer_times/view/set_up_prayer.dart';
import 'package:moemen/presentation/bottom_bar/screens/quran/cubit/quran_cubit.dart';
import 'package:moemen/presentation/bottom_bar/screens/settings/service/daily_alert.dart';
import 'package:moemen/presentation/bottom_bar/screens/settings/service/evening_alert.dart';
import 'package:moemen/presentation/bottom_bar/screens/settings/service/morning_alert.dart';
import 'package:moemen/presentation/bottom_bar/screens/settings/service/sorat_almolk_alert.dart';
import 'package:moemen/presentation/components/widget.dart';
import 'package:moemen/presentation/pay_builder/payment.dart';
import 'package:moemen/presentation/qibla/view/qiblah_screen.dart';
import 'package:moemen/presentation/surah_builder/view/surah_builder_view.dart';
import 'package:moemen/presentation/werd_builder/new_khetma.dart';
import 'package:moemen/presentation/werd_builder/next_werd.dart';
import 'package:moemen/presentation/werd_builder/previous_werd.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';
import '../../../cubit/bottom_bar_cubit.dart';
import '../service/sorat_albaqara_alert.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final InAppReview inAppReview = InAppReview.instance;




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
                      builder: (context) => SupportAppPage(),
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
                trailing: BlocBuilder<QuranCubit, QuranState>(
                  builder: (context, state) {
                    final cubit = context.read<QuranCubit>();
                    if (cubit.khetmaPlans.isEmpty) {
                      return Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('0'),
                      );
                    }
                    final khetma = cubit.khetmaPlans.first;
                    return Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${khetma.currentDayIndex}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  final cubit = context.read<QuranCubit>();
                  if (cubit.khetmaPlans.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("noKhetmaAvailable"),
                    ));
                    return;
                  }
                  final activeKhetma = cubit.khetmaPlans.first;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviousWerdsScreen(khetma: activeKhetma),
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.chevron_circle_left_48_regular,
                settingName: AppStrings.nextWerd.tr(),
                trailing: BlocBuilder<QuranCubit, QuranState>(
                  builder: (context, state) {
                    final cubit = context.read<QuranCubit>();
                    if (cubit.khetmaPlans.isEmpty) {
                      return Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('0'),
                      );
                    }
                    final khetma = cubit.khetmaPlans.first;
                    final nextWerd = khetma.durationDays-khetma.currentDayIndex ;
                    return Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${nextWerd}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  final activeKhetma = context.read<QuranCubit>().getActiveKhetma();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextWerd(khetma: activeKhetma),
                    ),
                  );
                },
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
                    Navigator.pushNamed(
                      context,
                      Routes.quranRoute,
                      arguments: {
                        "quranList": quranList,
                        "pageNo": bookMarkedPage, // SINGLE page number
                      },
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
                      builder: (context) => NewKhetmaPage(),
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.qiblaDirection.tr(), context: context),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.alert_48_filled,
                settingName: AppStrings.settingPrayerTime.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetUpPrayer(),
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: 'assets/images/kaaba.svg',
                icon: null,
                settingName: AppStrings.qiblaDirection.tr(),
                trailing: const SizedBox(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QiblahScreen(), // Replace with the page you want to navigate to
                    ),
                  );
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.adhkarAlarm.tr(), context: context),
              MorningAlert(),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.adhkarMorningTime.tr(),
                trailing: Text("07:00 AM",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSize.s14.sp,
                  wordSpacing: AppSize.s3.w,
                  letterSpacing: AppSize.s0_5.w,
                ),
                ),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              EveningAlert(),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.adhkarEveningTime.tr(),
                trailing: Text("05:30 PM",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSize.s14.sp,
                  wordSpacing: AppSize.s3.w,
                  letterSpacing: AppSize.s0_5.w,
                ),
                ),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              getSeparator(context),
              getTitle(
                  settingName: AppStrings.sonanAlarm.tr(), context: context),
              SoratAlmolkAlert(),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.soratAlMolkTime.tr(),
                trailing: Text("09:00 PM",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSize.s14.sp,
                  wordSpacing: AppSize.s3.w,
                  letterSpacing: AppSize.s0_5.w,
                ),
                ),
                onTap: () {},
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              SoratAlbaqarahAlert(),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.clock_48_regular,
                settingName: AppStrings.soratAlBaqarahTime.tr(),
                trailing: Text("08:30 PM",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSize.s14.sp,
                  wordSpacing: AppSize.s3.w,
                  letterSpacing: AppSize.s0_5.w,
                ),
                ),
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
                svgPath: 'assets/images/threads.svg',
                icon: null,
                settingName: AppStrings.threads.tr(),
                trailing: const SizedBox(),
                onTap: () async {
                  final Uri threadsUri = Uri.parse('https://www.threads.net/');

                  if (await canLaunchUrl(threadsUri)) {
                    await launchUrl(threadsUri, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch Threads';
                  }
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: 'assets/images/insta.svg',
                icon: null,
                settingName: AppStrings.instagram.tr(),
                trailing: const SizedBox(),
                onTap: () async {
                  const String username = 'your_username'; // Replace with your Instagram username
                  final Uri instaAppUri = Uri.parse('instagram://user?username=$username');
                  final Uri instaWebUri = Uri.parse('https://www.instagram.com/$username');

                  if (await canLaunchUrl(instaAppUri)) {
                    await launchUrl(instaAppUri);
                  } else {
                    await launchUrl(instaWebUri, mode: LaunchMode.externalApplication);
                  }
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.share_48_regular,
                settingName: AppStrings.share.tr(),
                trailing: const SizedBox(),
                onTap: () async {
                  const String appLink = 'https://play.google.com/store/apps/details?id=com.yourapp.package'; // Replace with your actual app link
                  await Share.share('Check out this amazing app: $appLink');
                },
                context: context,
                color: ColorManager.iconPrimary,
                angel: 0,
              ),
              settingIndexItem(
                svgPath: null,
                icon: FluentIcons.thumb_like_48_filled,
                settingName: AppStrings.appRating.tr(),
                trailing: const SizedBox(),
                onTap: () async {
                  if (await inAppReview.isAvailable()) {
                    await inAppReview.requestReview();
                  } else {
                    // Fallback to store listing if in-app review is not available
                    final String appStoreUrl = 'https://play.google.com/store/apps/details?id=com.yourapp.package'; // Replace with your actual app package name
                    await launchUrl(Uri.parse(appStoreUrl), mode: LaunchMode.externalApplication);
                  }
                },
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
