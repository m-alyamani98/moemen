import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For Icons

class AdhkarModel extends Equatable {
  final Map<String, String> category;
  final String count;
  final Map<String, String> dhikr;
  final IconData icon;

  const AdhkarModel({
    required this.category,
    required this.count,
    required this.dhikr,
    required this.icon,
  });

  @override
  List<Object> get props => [
    category,
    count,
    dhikr,
    icon,
  ];
}