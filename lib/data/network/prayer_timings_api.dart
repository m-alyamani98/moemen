import 'package:dio/dio.dart';

import 'package:retrofit/http.dart';

import '../../app/utils/constants.dart';
import '../responses/prayer_timings/prayer_timings_response.dart';

part 'prayer_timings_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class PrayerTimingsServiceClient {
  factory PrayerTimingsServiceClient(Dio dio, {String baseUrl}) =
  _PrayerTimingsServiceClient;

  @GET("{date}?city={city}&country={country}&school=0&method=5")
  Future<PrayerTimingsResponse> getPrayerTimings(
      @Path("date") String date,
      @Path("city") String city,
      @Path("country") String country,
      );
}
