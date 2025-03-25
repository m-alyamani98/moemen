import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/strings_manager.dart';
import 'package:moemen/app/resources/values.dart';
import 'package:moemen/presentation/bottom_bar/viewmodel/home_viewmodel.dart';
import 'package:moemen/presentation/components/separator.dart';

import '../../../../../app/resources/language_manager.dart';
import '../cubit/prayer_timings_cubit.dart';

class SetUpPrayer extends StatefulWidget {
  @override
  _SetUpPrayerState createState() => _SetUpPrayerState();
}

class _SetUpPrayerState extends State<SetUpPrayer> {

  final HomeViewModel viewModel = Get.find<HomeViewModel>();

  bool isLocationEnabled = false;
  bool _isCheckingLocation = false;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }


  Future<void> _checkLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() => _isCheckingLocation = true);

    LocationPermission permission = await Geolocator.checkPermission();

    bool hasPermission = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;

    setState(() {
      isLocationEnabled = serviceEnabled && hasPermission;
      _isCheckingLocation = false;
    });
  }

  Future<void> _requestLocationAccess() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    await _checkLocationStatus(); // This will update the state

    if (permission == LocationPermission.deniedForever) {
      _showLocationSettingsDialog();
    }
  }


  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringTranslateExtension(AppStrings.giveLocationAccessPermission).tr()),
          content: Text(StringTranslateExtension(AppStrings.locationSetup).tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(StringTranslateExtension(AppStrings.cancel).tr(),style: TextStyle(color: ColorManager.accentPrimary),),
            ),
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings(); // Open location settings
                Navigator.pop(context); // Close the dialog
              },
              child: Text(StringTranslateExtension(AppStrings.settings).tr(),style: TextStyle(color: ColorManager.primary),),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            StringTranslateExtension(AppStrings.locationSetup).tr(),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: ColorManager.primary),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              'assets/images/logoico.svg',
              width: AppSize.s20.r,
              height: AppSize.s20.r,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
              icon: Icon(FluentIcons.chevron_left_48_regular,color: ColorManager.iconPrimary),
            ),
          ],
        ),
      body: _isCheckingLocation
          ? Center(child: CircularProgressIndicator())
          : (isLocationEnabled
          ? setupLocationSuccessful(context)
          : setupLocationFaild(context)),
    );
  }

  Widget setupLocationFaild(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              child: Image.asset(
                'assets/images/location1.png',
              ),
            ),
            Text(StringTranslateExtension(AppStrings.setupLocation).tr()),
            SizedBox(height: 30),
            Text(StringTranslateExtension(AppStrings.setupLocationDesc).tr()),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {_requestLocationAccess();},
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                StringTranslateExtension(AppStrings.setupLocation).tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.homeRoute);
              },
              child: Text(
                StringTranslateExtension(AppStrings.skip).tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setupLocationSuccessful(BuildContext context) {
    final currentLocale = context.locale;
    bool isEnglish = currentLocale.languageCode == LanguageType.english.getValue();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: Image.asset(
            'assets/images/location2.png',
          ),
        ),
        Text(StringTranslateExtension(AppStrings.setupLocationSuccessful).tr()),
        SizedBox(height: 10),
        BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
          builder: (context, state) {
            final prayerCubit = context.read<PrayerTimingsCubit>();
            return Text(viewModel.locationTitle.value.isEmpty
                ? StringTranslateExtension(AppStrings.home).tr()
                : isEnglish ?  viewModel.locationTitle.value : viewModel.arabicLocationTitle.value);;
          },
        ),
        getSeparator(context),
        SizedBox(height: 50),
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, Routes.homeRoute);},
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
            child: Text(
              StringTranslateExtension(AppStrings.next).tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
