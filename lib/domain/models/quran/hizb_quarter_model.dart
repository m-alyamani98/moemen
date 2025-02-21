// lib/domain/models/quran/h izb_quarter_model.dart
class HizbQuarterModel {
  final int hizbQuarterNumber;
  final int juzNumber;
  final int quarterInJuz;
  final String name;
  final int startPage;

  HizbQuarterModel({
    required this.hizbQuarterNumber,
    required this.juzNumber,
    required this.quarterInJuz,
    required this.name,
    required this.startPage,
  });
}