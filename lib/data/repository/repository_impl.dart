import 'package:dartz/dartz.dart';
import 'package:moemen/data/mapper/mapper.dart'; // Ensure this mapper is still relevant or adjust/remove
import '../../app/error/exception.dart';
import '../../app/error/failure.dart';
import '../../di/di.dart';
import '../../domain/models/adhkar/adhkar_model.dart';
import '../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../domain/models/quran/quran_model.dart';
import '../../domain/models/quran/quran_search_model.dart';
import '../../domain/repository/repository.dart';
import '../data_source/local/local_data_source.dart';

// Import adhan_dart with prefix and intl for date formatting
import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:intl/intl.dart';

class RepositoryImpl implements Repository {
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  RepositoryImpl();

  @override
  Future<Either<Failure, List<AdhkarModel>>> getAdhkarData() async {
    final data = await _localDataSource.getAdhkarData();
    try {
      return Right(data.map((e) => e.toDomain()).toList());
    } on LocalException catch (failure) {
      return Left(LocalFailure(null, failure.message));
    }
  }

  @override
  Future<Either<Failure, List<QuranModel>>> getQuranData() async {
    final data = await _localDataSource.getQuranData();
    try {
      return Right(data.map((e) => e.toDomain()).toList());
    } on LocalException catch (failure) {
      return Left(LocalFailure(null, failure.message));
    }
  }

  @override
  Future<Either<Failure, List<QuranSearchModel>>> getQuranSearchData() async {
    final data = await _localDataSource.getQuranSearchData();
    try {
      return Right(data.map((e) => e.toDomain()).toList());
    } on LocalException catch (failure) {
      return Left(LocalFailure(null, failure.message));
    }
  }

  @override
  Future<Either<Failure, PrayerTimingsModel>> getPrayerTimings(
      DateTime date, double latitude, double longitude) async {
    try {
      final coordinates = adhan.Coordinates(latitude, longitude);

      // Use DateTime directly (no more DateComponents)
      final params = adhan.CalculationMethod.ummAlQura();
      params.madhab = adhan.Madhab.shafi;

      final prayerTimes = adhan.PrayerTimes(
        coordinates: coordinates,
        date: date,
        calculationParameters: params,
      );

      final DateFormat formatter = DateFormat('HH:mm');
      final timings = TimingsModel(
        fajr: formatter.format(prayerTimes.fajr!.toLocal()),
        sunrise: formatter.format(prayerTimes.sunrise!.toLocal()),
        dhuhr: formatter.format(prayerTimes.dhuhr!.toLocal()),
        asr: formatter.format(prayerTimes.asr!.toLocal()),
        maghrib: formatter.format(prayerTimes.maghrib!.toLocal()),
        isha: formatter.format(prayerTimes.isha!.toLocal()),
      );

      final prayerTimingsData = PrayerTimingsDataModel(
        timings: timings,
        date: null,
      );

      final prayerTimingsModel = PrayerTimingsModel(
        code: 200,
        status: "OK",
        data: prayerTimingsData,
      );

      return Right(prayerTimingsModel);
    } catch (e) {
      print("Error calculating prayer times locally: $e");
      return Left(LocalFailure(null, "Failed to calculate prayer times locally: ${e.toString()}"));
    }
  }

}

