import 'package:flutter/material.dart';
import '../../../../../app/resources/resources.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../screens/Home/view/home_screen.dart';
import '../screens/quran/view/quran_screen.dart';
import '../screens/settings/view/settings_screen.dart';
import '../screens/werd/view/daily_werd.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeViewModel extends GetxController {
  var locationTitle = ''.obs;
  var arabicLocationTitle = ''.obs;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String city = place.locality ?? "Unknown City";
      String country = place.country ?? "Unknown Country";

      locationTitle.value = "$city, $country";

      // Translation dictionary (you can expand it)
      Map<String, String> arabicTranslations = {
        "Amman": "عمان",
        "Jordan": "الأردن",
        "Unknown City": "مدينة غير معروفة",
        "Unknown Country": "دولة غير معروفة"
      };

      arabicLocationTitle.value =
      "${arabicTranslations[city] ?? city}, ${arabicTranslations[country] ?? country}";
    } catch (e) {
      locationTitle.value = "Location not available";
      arabicLocationTitle.value = "الموقع غير متوفر";
    }
  }

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  List<Widget> screens = [
    const HomeScreen(),
    WerdScreen(),
    const QuranScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    StringTranslateExtension(AppStrings.home).tr(),
    StringTranslateExtension(AppStrings.werd).tr(),
    StringTranslateExtension(AppStrings.fahras).tr(),
    StringTranslateExtension(AppStrings.settings).tr(),
  ];
}

class LanguageController extends GetxController {
  var isArabic = false.obs;

  void updateLanguage(String locale) {
    isArabic.value = locale == 'ar';
  }
}