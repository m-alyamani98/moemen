import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';

import '../../app/error/failure.dart';
import '../../di/di.dart';
import '../models/prayer_timings/prayer_timings_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GetPrayerTimingsUseCase
    implements
        BaseUseCase<GetPrayerTimingsUseCaseUseCaseInput, PrayerTimingsModel> {
  final Repository _repository = instance<Repository>();

  GetPrayerTimingsUseCase();

  @override
  Future<Either<Failure, PrayerTimingsModel>> call(
      GetPrayerTimingsUseCaseUseCaseInput input) async {
    return await _repository.getPrayerTimings(
        input.date, input.latitude, input.longitude);
  }
}

class GetPrayerTimingsUseCaseUseCaseInput extends Equatable {
  final DateTime date;
  final double latitude;
  final double longitude;

  const GetPrayerTimingsUseCaseUseCaseInput({
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [
    date,
    latitude,
    longitude,
  ];

  GetPrayerTimingsUseCaseUseCaseInput copyWith({
    DateTime? date,
    double? latitude,
    double? longitude,
  }) {
    return GetPrayerTimingsUseCaseUseCaseInput(
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
