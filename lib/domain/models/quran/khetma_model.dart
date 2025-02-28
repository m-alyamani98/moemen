import 'dart:convert';
import 'package:flutter/foundation.dart';

enum PortionType { Juz, Page, HizbQuarter }

class Khetma {
  int? id;
  final String name;
  final DateTime startDate;
  final int durationDays;
  final PortionType portionType;
  final int dailyAmount;
  final int startValue;
  final List<DayPlan> days;
  int currentDayIndex;

  Khetma({
    this.id,
    required this.name,
    required this.startDate,
    required this.durationDays,
    required this.portionType,
    required this.dailyAmount,
    required this.startValue,
    required this.days,
    this.currentDayIndex = 0,
  }) : assert(currentDayIndex >= 0 && currentDayIndex < days.length,
  'Invalid currentDayIndex');

  @override
  List<Object?> get props => [
    id,
    name,
    startDate,
    durationDays,
    portionType,
    dailyAmount,
    startValue,
    days,
    currentDayIndex,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Khetma &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              startDate == other.startDate &&
              durationDays == other.durationDays &&
              portionType == other.portionType &&
              dailyAmount == other.dailyAmount &&
              startValue == other.startValue &&
              listEquals(days, other.days) &&
              currentDayIndex == other.currentDayIndex;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      startDate.hashCode ^
      durationDays.hashCode ^
      portionType.hashCode ^
      dailyAmount.hashCode ^
      startValue.hashCode ^
      days.hashCode ^
      currentDayIndex.hashCode;


  factory Khetma.fromMap(Map<String, dynamic> map) {
    // Handle both string and list formats for days
    dynamic daysData = map['days'];
    List<dynamic> daysList = [];

    if (daysData is String) {
      daysList = jsonDecode(daysData);
    } else if (daysData is List) {
      daysList = daysData;
    }

    return Khetma(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['start_date']),
      durationDays: map['duration_days'],
      portionType: PortionType.values[map['portion_type']],
      dailyAmount: map['daily_amount'],
      startValue: map['start_value'],
      days: daysList.map((d) => DayPlan.fromMap(d)).toList(),
      currentDayIndex: map['current_day_index'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'duration_days': durationDays,
      'portion_type': portionType.index,
      'daily_amount': dailyAmount,
      'start_value': startValue,
      'days': days.map((d) => d.toMap()).toList(), // Will be overridden in DB ops
      'current_day_index': currentDayIndex,
    };
  }

  // Update copyWith
  Khetma copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    int? durationDays,
    PortionType? portionType,
    int? dailyAmount,
    int? startValue,
    List<DayPlan>? days,
    int? currentDayIndex,
  }) {
    return Khetma(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
      portionType: portionType ?? this.portionType,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      startValue: startValue ?? this.startValue,
      days: days ?? this.days,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
    );
  }
}

class DayPlan {
  final int dayNumber;
  final int start;
  final int end;
  final bool isCompleted;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DayPlan &&
              runtimeType == other.runtimeType &&
              dayNumber == other.dayNumber &&
              start == other.start &&
              end == other.end &&
              isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      dayNumber.hashCode ^
      start.hashCode ^
      end.hashCode ^
      isCompleted.hashCode;

  const DayPlan({
    required this.dayNumber,
    required this.start,
    required this.end,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'dayNumber': dayNumber,
      'start': start,
      'end': end,
      'isCompleted': isCompleted,
    };
  }

  factory DayPlan.fromMap(Map<String, dynamic> map) {
    return DayPlan(
      dayNumber: map['dayNumber'],
      start: map['start'],
      end: map['end'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  DayPlan copyWith({
    bool? isCompleted,
  }) {
    return DayPlan(
      dayNumber: dayNumber,
      start: start,
      end: end,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}