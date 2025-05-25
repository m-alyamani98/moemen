import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;
import '../../../../../di/di.dart';
import '../../../../../data/network/network_info.dart'; // Restore NetworkInfo import
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
    // Keep this state emission? It might trigger UI rebuilds unnecessarily
    // emit(GetConnectionLoadingState());
    try {
      isConnected = await networkInfo.isConnected;
      // emit(GetConnectionSuccessState()); // Avoid emitting state just for connectivity check unless UI depends on it
    } catch (error) {
      isConnected = false;
      // emit(GetConnectionErrorState(error.toString())); // Avoid emitting state unless UI needs to show connectivity error
    }
  }

  location_package.Location location = location_package.Location();

  PrayerTimingsModel prayerTimingsModel =
  const PrayerTimingsModel(code: 0, status: "", data: null);

  double? currentLatitude;
  double? currentLongitude;
  (String, String) recordLocation = ("", "");

  Future<void> getLocation() async {
    emit(GetLocationLoadingState());
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _handleError(AppStrings.enableLocation.tr());
          return;
        }
      }

      var permissionStatus = await location.hasPermission();
      if (permissionStatus == location_package.PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != location_package.PermissionStatus.granted) {
          _handleError(AppStrings.giveLocationAccessPermission.tr());
          return;
        }
      }

      final locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        _handleError(AppStrings.noLocationFound.tr());
        return;
      }

      currentLatitude = locationData.latitude!;
      currentLongitude = locationData.longitude!;
      debugPrint("Obtained coordinates: Lat: $currentLatitude, Lng: $currentLongitude");

      await isNetworkConnected(); // Check connection before geocoding
      if (isConnected) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            currentLatitude!, currentLongitude!,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final city = place.subAdministrativeArea ?? place.locality ?? place.administrativeArea ?? "Unknown City";
            final country = place.country ?? "Unknown Country";
            recordLocation = (city, country);
          } else {
            recordLocation = ("Unknown City", "Unknown Country");
          }
        } catch (e) {
          debugPrint("Geocoding error: $e");
          recordLocation = ("Geocoding Failed", "");
        }
      } else {
        recordLocation = ("Network needed for city/country", "");
      }
      emit(GetLocationSuccessState());
      // After getting location successfully, fetch prayer times
      await getPrayerTimings();
    } catch (e) {
      debugPrint("Location error: $e");
      _handleError("Location Error: ${e.toString()}");
    }
  }

  void _handleError(String errorMessage) {
    recordLocation = (errorMessage, errorMessage);
    emit(GetLocationErrorState(errorMessage));
  }

  Future<void> getPrayerTimings() async {
    // Only proceed if coordinates are available
    if (currentLatitude == null || currentLongitude == null) {
      // If called without location, try to get location first
      await getLocation();
      // If location still not available after trying, emit error
      if (currentLatitude == null || currentLongitude == null) {
        emit(GetPrayerTimesErrorState("Failed to get location coordinates for prayer times."));
        return;
      }
    }

    // Ensure we don't emit loading if already loading location
    if (state is! GetLocationLoadingState) {
      emit(GetPrayerTimesLoadingState());
    }

    DateTime dateNow = DateTime.now();
    final result = await _getPrayerTimingsUseCase(
      GetPrayerTimingsUseCaseUseCaseInput(
        date: dateNow,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
      ),
    );

    result.fold((l) {
      prayerTimingsModel = PrayerTimingsModel(code: 500, status: l.message, data: null);
      emit(GetPrayerTimesErrorState(l.message));
    }, (r) {
      prayerTimingsModel = r;
      emit(GetPrayerTimesSuccessState(r));
    });
  }

  // --- Helper methods for UI ---

  Map<String, DateTime> _getParsedPrayerTimes(TimingsModel timings) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Map<String, DateTime> parsedTimes = {};

    try {
      parsedTimes = {
        "Fajr": _parseTime(timings.fajr, today),
        "Sunrise": _parseTime(timings.sunrise, today),
        "Dhuhr": _parseTime(timings.dhuhr, today),
        "Asr": _parseTime(timings.asr, today),
        "Maghrib": _parseTime(timings.maghrib, today),
        "Isha": _parseTime(timings.isha, today),
      };
    } catch (e) {
      debugPrint("Error parsing prayer times: $e");
      return {}; // Return empty map on parsing error
    }

    // Create a list of (name, time) pairs for sorting
    var prayerList = parsedTimes.entries.toList();

    // Sort by time
    prayerList.sort((a, b) => a.value.compareTo(b.value));

    // Adjust times for prayers that cross midnight (relative to the *sorted* list)
    for (int i = 1; i < prayerList.length; i++) {
      if (prayerList[i].value.isBefore(prayerList[i-1].value)) {
        // If current prayer time is before previous, add a day
        parsedTimes[prayerList[i].key] = prayerList[i].value.add(const Duration(days: 1));
      }
    }

    // Specifically check if Fajr needs to be moved to the next day relative to Isha
    // This check should happen *after* the general sort/adjustment loop
    if (parsedTimes.containsKey("Isha") && parsedTimes.containsKey("Fajr") && parsedTimes["Fajr"]!.isBefore(parsedTimes["Isha"]!)) {
      parsedTimes["Fajr"] = parsedTimes["Fajr"]!.add(const Duration(days: 1));
    }

    return parsedTimes;
  }

  DateTime _parseTime(String time, DateTime date) {
    List<String> parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Map<String, String> getCurrentAndNextPrayer(bool isEnglish) {
    if (prayerTimingsModel.data == null || prayerTimingsModel.data!.timings == null) {
      return {"currentPrayer": "--", "nextPrayer": "--", "nextPrayerTime": "--:--"};
    }

    final now = DateTime.now();
    final timingsMap = _getParsedPrayerTimes(prayerTimingsModel.data!.timings!);
    if (timingsMap.isEmpty) { // Handle parsing error case
      return {"currentPrayer": "Error", "nextPrayer": "Error", "nextPrayerTime": "--:--"};
    }

    // Create a list of (Prayer Name, DateTime) pairs including Fajr for the next day
    List<MapEntry<String, DateTime>> prayerSchedule = timingsMap.entries.toList();
    // Add Fajr of the next day for comparison if needed
    if (timingsMap.containsKey("Fajr")) {
      prayerSchedule.add(MapEntry("Fajr", timingsMap["Fajr"]!.add(const Duration(days: 1))));
    }

    // Sort the schedule by time
    prayerSchedule.sort((a, b) => a.value.compareTo(b.value));

    String currentPrayer = "Isha";
    String nextPrayer = "Fajr";
    DateTime? nextPrayerDateTime;

    // Find the first prayer time strictly after 'now'
    for (int i = 0; i < prayerSchedule.length; i++) {
      if (prayerSchedule[i].value.isAfter(now)) {
        nextPrayer = prayerSchedule[i].key;
        nextPrayerDateTime = prayerSchedule[i].value;
        // The current prayer is the one before the next prayer in the sorted list
        // Handle wrap-around case (if next prayer is the first one, current is the last one from the original map)
        if (i == 0) {
          // Find the last prayer time in the original map (likely Isha)
          var sortedToday = timingsMap.entries.toList()..sort((a,b) => a.value.compareTo(b.value));
          currentPrayer = sortedToday.isNotEmpty ? sortedToday.last.key : "Isha";
        } else {
          currentPrayer = prayerSchedule[i - 1].key;
        }
        break; // Found the next prayer, exit loop
      }
    }

    // If the loop completes without finding a prayer after 'now',
    // it means 'now' is after today's Isha.
    // Current is Isha, Next is Fajr (already defaulted, time needs update)
    if (nextPrayerDateTime == null && timingsMap.containsKey("Fajr")) {
      nextPrayerDateTime = timingsMap["Fajr"]!.add(const Duration(days: 1));
      currentPrayer = "Isha"; // Explicitly set current to Isha
    }

    // Format the next prayer time
    String nextPrayerTimeStr = nextPrayerDateTime != null
        ? DateFormat.jm().format(nextPrayerDateTime.toLocal())
        : "--:--";

    // Exclude Sunrise from being displayed as current/next prayer if desired
    if (currentPrayer == "Sunrise") {
      // If current is Sunrise, find the prayer before Sunrise (Fajr)
      int sunriseIndex = prayerSchedule.indexWhere((p) => p.key == "Sunrise");
      if (sunriseIndex > 0) {
        currentPrayer = prayerSchedule[sunriseIndex - 1].key;
      } else { // Should not happen if Fajr exists
        currentPrayer = "Fajr";
      }
    }
    if (nextPrayer == "Sunrise") {
      // If next is Sunrise, find the prayer after Sunrise (Dhuhr)
      int sunriseIndex = prayerSchedule.indexWhere((p) => p.key == "Sunrise");
      if (sunriseIndex < prayerSchedule.length - 1) {
        nextPrayer = prayerSchedule[sunriseIndex + 1].key;
        nextPrayerDateTime = prayerSchedule[sunriseIndex + 1].value;
        nextPrayerTimeStr = DateFormat.jm().format(nextPrayerDateTime.toLocal());
      } else { // Should not happen if Dhuhr exists
        nextPrayer = "Dhuhr";
        // Recalculate time if needed, or leave as is if fallback is acceptable
      }
    }

    return {
      "currentPrayer": isEnglish ? currentPrayer : _translatePrayer(currentPrayer),
      "nextPrayer": isEnglish ? nextPrayer : _translatePrayer(nextPrayer),
      "nextPrayerTime": nextPrayerTimeStr
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
    if (prayerTimingsModel.data == null || prayerTimingsModel.data!.timings == null) return "--:--";

    final now = DateTime.now();
    final timingsMap = _getParsedPrayerTimes(prayerTimingsModel.data!.timings!);
    if (timingsMap.isEmpty) return "--:--"; // Handle parsing error

    // Create a list of (Prayer Name, DateTime) pairs including Fajr for the next day
    List<MapEntry<String, DateTime>> prayerSchedule = timingsMap.entries.toList();
    if (timingsMap.containsKey("Fajr")) {
      prayerSchedule.add(MapEntry("Fajr", timingsMap["Fajr"]!.add(const Duration(days: 1))));
    }
    prayerSchedule.sort((a, b) => a.value.compareTo(b.value));

    DateTime? nextPrayerTime;

    // Find the first prayer time strictly after 'now'
    for (final prayerEntry in prayerSchedule) {
      // Skip Sunrise if we don't want countdown to it
      // if (prayerEntry.key == "Sunrise") continue;

      if (prayerEntry.value.isAfter(now)) {
        nextPrayerTime = prayerEntry.value;
        break;
      }
    }

    // If loop finishes, next prayer is Fajr tomorrow (already handled by adding it to the list)
    // If nextPrayerTime is still null here, it means Fajr wasn't in the original map or something went wrong.
    if (nextPrayerTime == null) return "--:--";

    final diff = nextPrayerTime.difference(now);
    if (diff.isNegative) return "00:00"; // Should not happen with isAfter check

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }


  String getCurrentPrayerTime() {
    if (prayerTimingsModel.data == null || prayerTimingsModel.data!.timings == null) {
      return "--:--";
    }

    final now = DateTime.now();
    final timingsMap = _getParsedPrayerTimes(prayerTimingsModel.data!.timings!);
    if (timingsMap.isEmpty) return "--:--";

    List<MapEntry<String, DateTime>> prayerSchedule = timingsMap.entries.toList();
    prayerSchedule.add(MapEntry("Fajr", timingsMap["Fajr"]!.add(const Duration(days: 1))));
    prayerSchedule.sort((a, b) => a.value.compareTo(b.value));

    for (int i = 0; i < prayerSchedule.length; i++) {
      if (prayerSchedule[i].value.isAfter(now)) {
        int currentIndex = (i == 0) ? prayerSchedule.length - 1 : i - 1;
        return DateFormat.jm().format(prayerSchedule[currentIndex].value.toLocal());
      }
    }

    return timingsMap.containsKey("Isha")
        ? DateFormat.jm().format(timingsMap["Isha"]!.toLocal())
        : "--:--";
  }

}

