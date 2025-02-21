
import 'quran_model.dart';

class JuzModel {
  final int juzNumber;
  final int startingPage;
  final List<AyahModel> ayahs;

  JuzModel({
    required this.juzNumber,
    required this.startingPage,
    required this.ayahs,
  });
}