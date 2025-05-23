import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moemen/app/utils/extensions.dart';
import '../../../../../app/utils/constants.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/prayer_timings_cubit.dart';
import 'set_up_prayer.dart';

class PrayerTimingsScreen extends StatelessWidget {
  const PrayerTimingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
      builder: (context, state) {

        PrayerTimingsCubit cubit = PrayerTimingsCubit.get(context);
        PrayerTimingsModel prayerTimingsModel = cubit.prayerTimingsModel;
        bool isConnected = cubit.isConnected;

        final currentLocale = context.locale;
        bool isEnglish =
            currentLocale.languageCode == LanguageType.english.getValue();

        if (prayerTimingsModel.code == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.gettingLocation.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: AppSize.s5.h,
              ),
              Center(
                child: SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.55),
                    child: const LinearProgressIndicator(
                      color: ColorManager.primary,
                    )),
              ),
            ],
          );
        } else if (prayerTimingsModel.code == 200) {
          List<String> timings = [
            prayerTimingsModel.data!.timings!.fajr.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.sunrise.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.dhuhr.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.asr.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.maghrib.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.isha.convertTo12HourFormat(),
          ];
          // Get the current and next prayer
          Map<String, String> prayers = cubit.getCurrentAndNextPrayer(isEnglish);
          final currentPrayer = prayers["currentPrayer"];
          final nextPrayer = prayers["nextPrayer"];
          final nextPrayerTime = prayers["nextPrayerTime"];
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSize.s20.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorManager.accentPrimary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var index = 0; index < Constants.prayerNumbers; index++)
                          _prayerIndexItem(
                            isEnglish: isEnglish,
                            context: context,
                            timings: timings,
                            prayerTimingsModel: prayerTimingsModel,
                            index: index,
                            currentPrayer: currentPrayer ?? '',
                            svg: _getPrayerSvgPath(index)
                          )

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.s20.h,
                ),
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: ColorManager.accentPrimary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill( // Ensures the SVG fills the container
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0), // Optional: same radius for rounded corners
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: isEnglish ? Matrix4.rotationY(3.1416) : Matrix4.identity(),
                            child: SvgPicture.asset(
                              'assets/images/background.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(isEnglish
                                      ? "$currentPrayer"
                                      : "$currentPrayer",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: ColorManager.white)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: AppSize.s5.h),
                                    child: Text(
                                      isEnglish
                                          ? prayerTimingsModel.data!.date!.gregorian!.weekday!.en
                                          : prayerTimingsModel.data!.date!.hijri!.weekday!.ar,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          color: ColorManager.white
                                      ),
                                    ),
                                  ),
                                  Text(isEnglish
                                      ? "Next Prayer: $nextPrayer"
                                      : "الصلاة التالية: $nextPrayer",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: ColorManager.white)),
                                  Text(
                                    isEnglish
                                        ? "Time Left: ${cubit.getTimeUntilNextPrayer()}"
                                        : "الوقت المتبقي: ${cubit.getTimeUntilNextPrayer()}",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: ColorManager.white
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
            ],
            ),
          );
        } else {
          if (!isConnected) {
            return Center(
                child: Text(
                  AppStrings.noInternetConnection.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: AppSize.s1_3.h),
                ));
          } else {
            return Center(
                child: Column(
                  children: [
                    Text(
                      AppStrings.noLocationFound.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(height: AppSize.s1_3.h),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetUpPrayer(),
                            ),
                          );
                        },
                        child: Text("Set up prayer times")
                    )
                  ],
                ));
          }
        }
      },
    );
  }

  Widget _prayerIndexItem({
    required PrayerTimingsModel prayerTimingsModel,
    required List<String> timings,
    required int index,
    required bool isEnglish,
    required BuildContext context,
    required String currentPrayer,
    required String svg
  }) {
    // Determine the prayer name based on the current language
    final prayerName = isEnglish
        ? AppStrings.englishPrayerNames[index]
        : AppStrings.arabicPrayerNames[index];

    final isCurrentPrayer = prayerName == currentPrayer;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentPrayer
            ? ColorManager.primary
            : ColorManager.accentPrimary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
              width: 20,
              height:20,
              fit: BoxFit.contain,
              color: isCurrentPrayer
                  ? ColorManager.white
                  : ColorManager.primary,
            ),
            SizedBox(
              height: AppSize.s3.h,
            ),
            Text(
              prayerName,
              style: TextStyle(
                fontFamily: FontConstants.elMessiriFontFamily,
                fontSize: 14,
                color: isCurrentPrayer
                    ? ColorManager.white
                    : ColorManager.primary,
              ),
            ),
            SizedBox(
              height: AppSize.s0_1.h,
            ),
            Text(
              timings[index],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: FontConstants.uthmanTNFontFamily,
                color: isCurrentPrayer
                    ? ColorManager.white
                    : ColorManager.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }



  String _getPrayerSvgPath(int index) {
    const List<String> prayerSvgPaths = [
      'assets/images/fajar.svg',
      'assets/images/sun.svg',
      'assets/images/sunset.svg',
      'assets/images/aser.svg',
      'assets/images/sunset2.svg',
      'assets/images/moon.svg',
    ];
    return prayerSvgPaths[index];
  }

}

