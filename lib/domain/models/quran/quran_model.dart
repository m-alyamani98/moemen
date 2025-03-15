import 'package:equatable/equatable.dart';
import 'package:moemen/domain/models/quran/juz_model.dart';

class AyahModel extends Equatable {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int page;
  final int hizbQuarter;

  const AyahModel({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    required this.hizbQuarter,
  });

  @override
  List<Object> get props => [
    number,
    text,
    numberInSurah,
    juz,
    page,
    hizbQuarter,
  ];
}


class QuranModel extends Equatable {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<AyahModel> ayahs;
  final List<JuzModel> juzs;  // Add this field for Juz grouping

  const QuranModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
    required this.juzs,  // Initialize this field in the constructor
  });

  @override
  List<Object> get props => [
    number,
    name,
    englishName,
    englishNameTranslation,
    revelationType,
    ayahs,
    juzs,  // Add this to the equality check
  ];
}
