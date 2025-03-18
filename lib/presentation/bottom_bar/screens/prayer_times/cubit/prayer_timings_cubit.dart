import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;

import '../../../../../app/utils/constants.dart';
import '../../../../../di/di.dart';
import '../../../../../data/network/network_info.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../../../../domain/usecase/get_prayer_timings_usecase.dart';
import '../../../../../app/resources/resources.dart';

part 'prayer_timings_state.dart';

class PrayerTimingsCubit extends Cubit<PrayerTimingsState> {
  final GetPrayerTimingsUseCase _getPrayerTimingsUseCase =
      instance<GetPrayerTimingsUseCase>();
  final NetworkInfo networkInfo = instance<NetworkInfo>();

  PrayerTimingsCubit() : super(PrayerTimesInitialState());

  static PrayerTimingsCubit get(context) => BlocProvider.of(context);

  bool isConnected = false;

  Future<void> isNetworkConnected() async {
    emit(GetConnectionLoadingState());
    await networkInfo.isConnected.then((value) {
      isConnected = value;
      emit(GetConnectionSuccessState());
    }).catchError((error) {
      emit(GetConnectionErrorState(error.toString()));
    });
  }

  location_package.Location location = location_package.Location();

  PrayerTimingsModel prayerTimingsModel =
      const PrayerTimingsModel(code: 0, status: "", data: null);

   (String, String) recordLocation = ("", "");

  Future<void> getLocation() async {
    emit(GetLocationLoadingState());

    try {
      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _handleError(AppStrings.enableLocation.tr());
          return;
        }
      }

      // Check location permissions
      var permissionStatus = await location.hasPermission();
      if (permissionStatus == location_package.PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
      }

      if (permissionStatus != location_package.PermissionStatus.granted) {
        _handleError(AppStrings.giveLocationAccessPermission.tr());
        return;
      }

      // Retrieve current location coordinates
      final locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        _handleError(AppStrings.noLocationFound.tr());
        return;
      }

      // Ensure network connectivity for geocoding
      if (!isConnected) {
        await isNetworkConnected();
        if (!isConnected) {
          _handleError(AppStrings.noInternetConnection.tr());
          return;
        }
      }

      // Convert coordinates to placemarks
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isEmpty) {
        _handleError(AppStrings.noLocationFound.tr());
        return;
      }

      // Extract city and country with fallbacks
      final place = placemarks.first;
      String city = place.subAdministrativeArea ??
          place.locality ??
          place.administrativeArea ??
          AppStrings.noLocationFound.tr();
      String country = place.country ?? AppStrings.noLocationFound.tr();

      recordLocation = (city, country);
      emit(GetLocationSuccessState());
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String errorMessage) {
    recordLocation = (errorMessage, errorMessage);
    emit(GetLocationErrorState(errorMessage));
  }

  Future<void> getPrayerTimings() async {
    emit(GetPrayerTimesLoadingState());
    if (recordLocation.$1 == "" || recordLocation.$2 == "") {
      await getLocation();
    }
    DateTime dateNow = DateTime.now();
    var formatter = DateFormat("dd-MM-yyy");
    String formattedDate = formatter.format(dateNow);
    final result =
        await _getPrayerTimingsUseCase(GetPrayerTimingsUseCaseUseCaseInput(
      date: formattedDate,
      city: recordLocation.$1,
      country: recordLocation.$2,
    ));
    result.fold((l) {
      prayerTimingsModel =
          PrayerTimingsModel(code: l.code!, status: l.message, data: null);
      emit(GetPrayerTimesErrorState(l.message));
    }, (r) {
      prayerTimingsModel = r;
      emit(GetPrayerTimesSuccessState(r));
    });
    // return prayerTimingsModel;
  }
  Map<String, DateTime> _getParsedPrayerTimes(TimingsModel timings) {
    DateTime now = DateTime.now();
    return {
      "Fajr": _parseTime(timings.fajr, now),
      "Dhuhr": _parseTime(timings.dhuhr, now),
      "Asr": _parseTime(timings.asr, now),
      "Maghrib": _parseTime(timings.maghrib, now),
      "Isha": _parseTime(timings.isha, now),
      "Sunrise": _parseTime(timings.sunrise, now),
    };
  }

  DateTime _parseTime(String time, DateTime currentDate) {
    List<String> parts = time.split(":");
    return DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Map<String, String> getCurrentAndNextPrayer(bool isEnglish) {
    if (prayerTimingsModel.data == null || prayerTimingsModel.data?.timings == null) {
      return {
        "currentPrayer": isEnglish ? "Prayer timings not available" : "مواقيت الصلاة غير متوفرة",
        "nextPrayer": ""
      };
    }

    TimingsModel timings = prayerTimingsModel.data!.timings!;
    Map<String, DateTime> prayerTimes = _getParsedPrayerTimes(timings);

    DateTime now = DateTime.now();

    // Prayer names in English and Arabic
    Map<String, String> prayerNamesEn = {
      "Fajr": "Fajr",
      "Sunrise": "Sunrise",
      "Dhuhr": "Dhuhr",
      "Asr": "Asr",
      "Maghrib": "Maghrib",
      "Isha": "Isha",
    };

    Map<String, String> prayerNamesAr = {
      "Fajr": "الفجر",
      "Sunrise": "الشروق",
      "Dhuhr": "الظهر",
      "Asr": "العصر",
      "Maghrib": "المغرب",
      "Isha": "العشاء",
    };

    // Sort prayer times by their DateTime
    List<MapEntry<String, DateTime>> sortedPrayerTimes = prayerTimes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    String? currentPrayer;
    String? nextPrayer;

    for (int i = 0; i < sortedPrayerTimes.length; i++) {
      if (sortedPrayerTimes[i].value.isBefore(now)) {
        currentPrayer = sortedPrayerTimes[i].key;
      } else {
        nextPrayer = sortedPrayerTimes[i].key;
        break;
      }
    }

    // Handle the case when all prayers for the day have passed
    nextPrayer ??= sortedPrayerTimes.first.key;

    String currentPrayerName = currentPrayer != null
        ? (isEnglish ? prayerNamesEn[currentPrayer]! : prayerNamesAr[currentPrayer]!)
        : (isEnglish ? "None" : "لا يوجد");

    String nextPrayerName = isEnglish
        ? prayerNamesEn[nextPrayer]!
        : prayerNamesAr[nextPrayer]!;

    return {
      "currentPrayer": currentPrayerName,
      "nextPrayer": nextPrayerName,
    };
  }



}
