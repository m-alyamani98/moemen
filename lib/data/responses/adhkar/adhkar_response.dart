import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adhkar_response.g.dart';

@JsonSerializable()
class AdhkarResponse {
  @JsonKey(name: "category")
  Map<String, String> category;
  @JsonKey(name: "count")
  String count;
  @JsonKey(name: "dhikr")
  Map<String, String> dhikr;

  AdhkarResponse(
      this.category,
      this.count,
      this.dhikr,
      );

  factory AdhkarResponse.fromJson(Map<String, dynamic> json) =>
      _$AdhkarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdhkarResponseToJson(this);
}
