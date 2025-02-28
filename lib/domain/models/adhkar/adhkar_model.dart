import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For Icons

class AdhkarModel extends Equatable {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String dhikr;
  final IconData icon;

  const AdhkarModel({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.dhikr,
    required this.icon,
  });

  @override
  List<Object> get props => [
    category,
    count,
    description,
    reference,
    dhikr,
    icon,
  ];
}