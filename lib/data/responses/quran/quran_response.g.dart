// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahResponse _$AyahResponseFromJson(Map<String, dynamic> json) => AyahResponse(
      (json['number'] as num).toInt(),
      json['text'] as String,
      (json['numberInSurah'] as num).toInt(),
      (json['juz'] as num).toInt(),
      (json['page'] as num).toInt(),
      (json['hizbQuarter'] as num).toInt(),
    );

Map<String, dynamic> _$AyahResponseToJson(AyahResponse instance) =>
    <String, dynamic>{
      'number': instance.number,
      'text': instance.text,
      'numberInSurah': instance.numberInSurah,
      'juz': instance.juz,
      'page': instance.page,
      'hizbQuarter': instance.hizbQuarter,
    };

QuranResponse _$QuranResponseFromJson(Map<String, dynamic> json) =>
    QuranResponse(
      (json['number'] as num).toInt(),
      json['name'] as String,
      json['englishName'] as String,
      json['englishNameTranslation'] as String,
      json['revelationType'] as String,
      (json['ayahs'] as List<dynamic>)
          .map((e) => AyahResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuranResponseToJson(QuranResponse instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'englishName': instance.englishName,
      'englishNameTranslation': instance.englishNameTranslation,
      'revelationType': instance.revelationType,
      'ayahs': instance.ayahs,
    };
