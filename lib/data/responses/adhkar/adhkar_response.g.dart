// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adhkar_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdhkarResponse _$AdhkarResponseFromJson(Map<String, dynamic> json) =>
    AdhkarResponse(
      Map<String, String>.from(json['category'] as Map),
      json['count'] as String,
      Map<String, String>.from(json['dhikr'] as Map),
    );

Map<String, dynamic> _$AdhkarResponseToJson(AdhkarResponse instance) =>
    <String, dynamic>{
      'category': instance.category,
      'count': instance.count,
      'dhikr': instance.dhikr,
    };
