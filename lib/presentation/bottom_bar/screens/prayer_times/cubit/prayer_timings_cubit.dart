import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;
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
      // Check network connectivity first
      if (!isConnected) {
        await isNetworkConnected();
        if (!isConnected) {
          _handleError(AppStrings.noInternetConnection.tr());
          return;
        }
      }

      // Check location service
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _handleError(AppStrings.enableLocation.tr());
          return;
        }
      }

      // Check permissions
      var permissionStatus = await location.hasPermission();
      if (permissionStatus == location_package.PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != location_package.PermissionStatus.granted) {
          _handleError(AppStrings.giveLocationAccessPermission.tr());
          return;
        }
      }

      // Get coordinates
      final locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        _handleError(AppStrings.noLocationFound.tr());
        return;
      }

      // Debugging: Print coordinates
      debugPrint('''Obtained coordinates: 
      Lat: ${locationData.latitude}, 
      Lng: ${locationData.longitude}''');

      // Get placemarks with better error handling
      List<Placemark> placemarks;
      try {
        placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );
      } catch (e) {
        debugPrint('Geocoding error: $e');
        _handleError("AppStrings.geocodingFailed.tr()");
        return;
      }

      if (placemarks.isEmpty) {
        _handleError(AppStrings.noLocationFound.tr());
        return;
      }

      // Enhanced placemark parsing
      final place = placemarks.first;
      final city = place.subAdministrativeArea ??
          place.locality ??
          place.administrativeArea ??
          "AppStrings.unknownCity.tr()";

      final country = place.country ?? "AppStrings.unknownCountry.tr()";

      recordLocation = (city, country);
      emit(GetLocationSuccessState());
    } catch (e) {
      debugPrint('Location error: $e');
      _handleError("AppStrings.locationError.tr()");
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
    if (prayerTimingsModel.data == null || prayerTimingsModel.data!.timings == null) {
      return {"currentPrayer": "", "nextPrayer": "", "nextPrayerTime": ""};
    }

    final now = DateTime.now();
    final timings = _getParsedPrayerTimes(prayerTimingsModel.data!.timings!);

    final orderedPrayerKeys = [
      "Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"
    ];

    String? currentPrayer;
    String? nextPrayer;
    String? nextPrayerTime;

    for (int i = 0; i < orderedPrayerKeys.length; i++) {
      String prayer = orderedPrayerKeys[i];
      DateTime time = timings[prayer]!;

      if (now.isBefore(time)) {
        currentPrayer = i > 0 ? orderedPrayerKeys[i - 1] : orderedPrayerKeys.last;
        nextPrayer = prayer;
        nextPrayerTime = DateFormat.jm().format(time); // 12hr format
        break;
      }
    }

    // If all prayers passed today, next is Fajr tomorrow
    nextPrayer ??= "Fajr";
    nextPrayerTime ??= DateFormat.jm().format(
        _parseTime(prayerTimingsModel.data!.timings!.fajr, now.add(Duration(days: 1))));

    currentPrayer ??= orderedPrayerKeys.last;

    return {
      "currentPrayer": isEnglish ? currentPrayer : _translatePrayer(currentPrayer),
      "nextPrayer": isEnglish ? nextPrayer : _translatePrayer(nextPrayer),
      "nextPrayerTime": nextPrayerTime
    };
  }

  String _translatePrayer(String prayerName) {
    Map<String, String> arabicMap = {
      "Fajr": "الفجر",
      "Sunrise": "الشروق",
      "Dhuhr": "الظهر",
      "Asr": "العصر",
      "Maghrib": "المغرب",
      "Isha": "العشاء",
    };
    return arabicMap[prayerName] ?? prayerName;
  }

  String getTimeUntilNextPrayer() {
    if (prayerTimingsModel.data == null) return "--:--";

    final timings = prayerTimingsModel.data!.timings!;
    final now = DateTime.now();

    final prayerTimes = _getParsedPrayerTimes(timings);
    final sortedTimes = prayerTimes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (var entry in sortedTimes) {
      if (entry.value.isAfter(now)) {
        final diff = entry.value.difference(now);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
    }

    // If all prayers have passed, return time until Fajr tomorrow
    final fajrTomorrow = prayerTimes["Fajr"]!.add(Duration(days: 1));
    final diff = fajrTomorrow.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }





}
