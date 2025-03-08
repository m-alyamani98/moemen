import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momen/data/database/database_helper.dart';
import 'package:momen/domain/models/quran/khetma_model.dart';
import '../../../../../app/utils/constants.dart';
import '../../../../../di/di.dart';
import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../../domain/models/quran/quran_search_model.dart';
import '../../../../../domain/usecase/base_usecase.dart';
import '../../../../../domain/usecase/quran_search_usecase.dart';
import '../../../../../domain/usecase/quran_usecase.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Khetma> khetmaPlans = [];

  final QuranUseCase _quranUseCase = instance<QuranUseCase>();

  final QuranSearchUseCase _quranSearchUseCase = instance<QuranSearchUseCase>();

  QuranCubit() : super(QuranInitial());

  static QuranCubit get(context) => BlocProvider.of(context);

  List<QuranModel> quranData = [];
  List<AyahModel> ayahData = [];


  List<int> pageToJuz = List.filled(604, 0);

  Future getQuranData() async {
    emit(QuranGetDataLoadingState());
    final result = await _quranUseCase(const NoParameters());
    result.fold((l) => emit(QuranGetDataErrorState(l.message)), (r) {
      quranData = r;
      precomputePageToJuz(); // <-- أضف هذه السطر
      emit(QuranGetDataSuccessState(r));
    });
  }

  Future getQuranSearchData() async {
    emit(QuranSearchGetDataLoadingState());
    final result = await _quranSearchUseCase(const NoParameters());
    result.fold((l) => emit(QuranSearchGetDataErrorState(l.message)), (r) {
      quranSearchData = r;
      emit(QuranSearchGetDataSuccessState(r));
    });
  }

  List<AyahModel> getAyahsFromPageNo({
    required List<QuranModel> quranList,
    required int pageNo,
  }) {
    List<AyahModel> ayahs = List.from(quranList
        .expand((surah) => (surah.ayahs.where((ayah) => ayah.page == pageNo))));
    return ayahs;
  }

  List<AyahModel> getHizbQuarterAyahs(int hizbQuarterIndex, List<QuranModel> quranList) {
    List<AyahModel> ayahs = [];
    for (var surah in quranList) {
      ayahs.addAll(surah.ayahs.where((ayah) => ayah.hizbQuarter == hizbQuarterIndex));
    }
    return ayahs;
  }

  List<String> getHizbQuarterNames() {
    return List.generate(240, (index) => "الحزب الربع ${index + 1}");
  }

  Map<String, dynamic> getHizbQuarterStartingPageAndAyah(int hizbQuarterIndex, List<QuranModel> quranList) {
    List<AyahModel> hizbQuarterAyahs = getHizbQuarterAyahs(hizbQuarterIndex, quranList);
    int startingPage = hizbQuarterAyahs.isNotEmpty ? hizbQuarterAyahs.first.page : 0;
    AyahModel? startingAyah = hizbQuarterAyahs.isNotEmpty ? hizbQuarterAyahs.first : null;

    return {
      'startingPage': startingPage,
      'startingAyah': startingAyah,
    };
  }

  List<QuranModel> getPageSurahs({
    required List<QuranModel> quran,
    required int pageNo,
  }) {
    List<QuranModel> pageSurahsNames = [];
    for (var i = 0; i < quran.length; i++) {
      final surah = quran[i];
      final List<AyahModel> ayahs = surah.ayahs;
      for (var ayah in ayahs) {
        if (ayah.page == pageNo) {
          pageSurahsNames.add(surah);
        }
      }
    }
    return pageSurahsNames.toSet().toList();
  }
  List<String> getJuzNames() {
    return [
      "الجزء الأول",
      "الجزء الثاني",
      "الجزء الثالث",
      "الجزء الرابع",
      "الجزء الخامس",
      "الجزء السادس",
      "الجزء السابع",
      "الجزء الثامن",
      "الجزء التاسع",
      "الجزء العاشر",
      "الجزء الحادي عشر",
      "الجزء الثاني عشر",
      "الجزء الثالث عشر",
      "الجزء الرابع عشر",
      "الجزء الخامس عشر",
      "الجزء السادس عشر",
      "الجزء السابع عشر",
      "الجزء الثامن عشر",
      "الجزء التاسع عشر",
      "الجزء العشرون",
      "الجزء الحادي والعشرون",
      "الجزء الثاني والعشرون",
      "الجزء الثالث والعشرون",
      "الجزء الرابع والعشرون",
      "الجزء الخامس والعشرون",
      "الجزء السادس والعشرون",
      "الجزء السابع والعشرون",
      "الجزء الثامن والعشرون",
      "الجزء التاسع والعشرون",
      "الجزء الثلاثون"
    ];
  }


  List<AyahModel> getJuzAyahs(int juzIndex, List<QuranModel> quranList) {
    List<AyahModel> ayahs = [];
    for (var surah in quranList) {
      ayahs.addAll(surah.ayahs.where((ayah) => ayah.juz == juzIndex));
    }
    return ayahs;
  }

  void precomputePageToJuz() {
    pageToJuz = List.filled(604, 1); // القيمة الافتراضية 1
    for (int juz = 1; juz <= 30; juz++) {
      final ayahs = getJuzAyahs(juz, quranData);
      if (ayahs.isEmpty) continue;

      final startPage = ayahs.first.page;
      final endPage = ayahs.last.page;

      for (int page = startPage; page <= endPage; page++) {
        if (page >= 1 && page <= 604) {
          pageToJuz[page - 1] = juz;
        }
      }
    }
  }

  // New methods for Khetma
  int getJuzNumberFromName(String juzName) {
    return getJuzNames().indexOf(juzName) + 1;
  }

  int getPageForJuz(int juzNumber) {
    final ayahs = getJuzAyahs(juzNumber, quranData);
    if (ayahs.isEmpty) {
      print("No ayahs found for Juz $juzNumber");
      return 1; // Default to page 1 if no ayahs are found
    }
    final page = ayahs.first.page;
    print("Juz $juzNumber starts at page $page");
    return page;
  }

  int getHizbQuarterStartingPage(int hizbQuarter) {
    final ayahs = getHizbQuarterAyahs(hizbQuarter, quranData);
    if (ayahs.isEmpty) {
      print("No ayahs found for Hizb Quarter $hizbQuarter");
      return 1; // Default to page 1 if no ayahs are found
    }
    final page = ayahs.first.page;
    print("Hizb Quarter $hizbQuarter starts at page $page");
    return page;
  }

  Future<void> loadKhetmas() async {
    emit(QuranGetDataLoadingState());
    khetmaPlans = await _databaseHelper.getAllKhetmas();
    emit(QuranGetDataSuccessState(quranData));
  }

  void createKhetmaPlan({
    required String name,
    required String startingPoint,
    required int duration,
    required PortionType dailyWirdType, // Fixed parameter name (Wird instead of Werd)
    required int dailyAmount,
  }) async {
    // Calculate startValue FIRST
    precomputePageToJuz();
    int startValue;
    try {
      if (getJuzNames().contains(startingPoint)) {
        startValue = getJuzNumberFromName(startingPoint);
      } else if (startingPoint.startsWith('صفحة ')) {
        startValue = int.parse(startingPoint.split(' ')[1]);
      } else if (startingPoint.startsWith('ربع ')) {
        startValue = int.parse(startingPoint.split(' ')[1]);
      } else {
        throw Exception('Invalid starting point');
      }
    } catch (e) {
      emit(QuranErrorState('Invalid starting point format'));
      return;
    }

    // NOW initialize current with startValue
    int current = startValue;
    final days = <DayPlan>[];

    // Populate days list
    for (int day = 1; day <= duration; day++) {
      final end = current + dailyAmount - 1;
      days.add(DayPlan(
        dayNumber: day,
        start: current,
        end: end,
      ));
      current = end + 1;
    }

    // Create Khetma with correct parameter name
    final newKhetma = Khetma(
      name: name,
      startDate: DateTime.now(),
      durationDays: duration,
      portionType: dailyWirdType, // Match parameter name
      dailyAmount: dailyAmount,
      startValue: startValue,
      days: days,
      currentDayIndex: 0,
    );

    final id = await _databaseHelper.insertKhetma(newKhetma);
    newKhetma.id = id;

    khetmaPlans.add(newKhetma);
    emit(KhetmaCreatedState(newKhetma));
  }


  Future<void> completeCurrentWerd(Khetma khetma) async {
    try {
      final index = khetmaPlans.indexWhere((k) => k.id == khetma.id);
      if (index == -1) return;

      final clampedIndex = khetma.currentDayIndex.clamp(0, khetma.days.length - 1);

      // Update current day status
      final newDays = List<DayPlan>.from(khetma.days);
      newDays[clampedIndex] = newDays[clampedIndex].copyWith(isCompleted: true);

      // Check if this is the last Werd
      final isLastWerd = clampedIndex == khetma.days.length - 1;

      // Calculate next index
      final newIndex = isLastWerd ? clampedIndex : clampedIndex + 1;

      final updatedKhetma = khetma.copyWith(
        days: newDays,
        currentDayIndex: newIndex,
      );

      khetmaPlans[index] = updatedKhetma;

      if (isLastWerd) {
        // Mark Khetma as finished and delete it from the database
        await _databaseHelper.deleteKhetma(khetma.id!);
        khetmaPlans.removeAt(index);
        emit(KhetmaFinishedState(updatedKhetma)); // Emit a new state for Khetma finished
      } else {
        // Update Khetma in the database
        await _databaseHelper.updateKhetma(updatedKhetma);
      }

      emit(QuranGetDataSuccessState(quranData));
    } catch (e) {
      emit(QuranErrorState('Error completing werd: ${e.toString()}'));
    }
  }

  // In QuranCubit
  Future<void> updateKhetma(Khetma updatedKhetma) async {
    try {
      final index = khetmaPlans.indexWhere((k) => k.id == updatedKhetma.id);
      if (index != -1) {
        khetmaPlans[index] = updatedKhetma;
        await _databaseHelper.updateKhetma(updatedKhetma);
        emit(QuranGetDataSuccessState(quranData));
      }
    } catch (e) {
      emit(QuranErrorState('Failed to update khetma: ${e.toString()}'));
    }
  }

  void updateKhetmaProgress(Khetma khetma, int dayIndex) {
    final newDays = List<DayPlan>.from(khetma.days);
    newDays[dayIndex] = newDays[dayIndex].copyWith(
        isCompleted: !newDays[dayIndex].isCompleted
    );

    final newKhetma = khetma.copyWith(days: newDays);

    final indexInList = khetmaPlans.indexOf(khetma);
    khetmaPlans[indexInList] = newKhetma;

    emit(KhetmaUpdatedState(newKhetma));
  }

  Map<String, dynamic> getCurrentWerdDetails(Khetma khetma) {
    if (khetma.days.isEmpty || quranData.isEmpty) {
      return {
        'start': {'page': 0, 'surahs': '', 'juz': ''},
        'end': {'page': 0, 'surahs': '', 'juz': ''}
      };
    }

    final clampedIndex = khetma.currentDayIndex.clamp(0, khetma.days.length - 1);
    final currentDay = khetma.days[clampedIndex];

    // تأكد من أن القيم ضمن النطاق الصحيح
    final startValue = currentDay.start.clamp(1, 604); // الصفحات من 1 إلى 604
    final endValue = currentDay.end.clamp(1, 604);

    final startPage = _getStartingPageForPortion(startValue, khetma);
    final endPage = _getStartingPageForPortion(endValue, khetma);

    // تجنب الوصول إلى فهارس غير صالحة
    final startJuzNumber = (startPage >= 1 && startPage <= 604) ? pageToJuz[startPage - 1] : 1;
    final endJuzNumber = (endPage >= 1 && endPage <= 604) ? pageToJuz[endPage - 1] : 1;



    final currentDayIndex = khetma.currentDayIndex.clamp(0, khetma.days.length - 1);
    print("Current Day: ${currentDay.dayNumber}, Start: ${currentDay.start}, End: ${currentDay.end}");


    // Get Surah information
    final startSurahs = getPageSurahs(quran: quranData, pageNo: startPage);
    final endSurahs = getPageSurahs(quran: quranData, pageNo: endPage);
    print("Start Surahs: ${startSurahs.map((s) => s.name).join(', ')}");
    print("End Surahs: ${endSurahs.map((s) => s.name).join(', ')}");

    print("Start Juz: ${getJuzNames()[startJuzNumber - 1]}");
    print("End Juz: ${getJuzNames()[endJuzNumber - 1]}");

    // Get Ayahs for start and end pages
    final startAyahs = getAyahsFromPageNo(quranList: quranData, pageNo: startPage);
    final endAyahs = getAyahsFromPageNo(quranList: quranData, pageNo: endPage);
    print("Start Ayahs: ${startAyahs.length}, End Ayahs: ${endAyahs.length}");

    return {
      'start': {
        'page': startPage,
        'surahs': startSurahs.map((s) => s.name).join(', '),
        'juz': getJuzNames()[startJuzNumber - 1],
        'num_ayahs': startAyahs.length,
        'first_ayah': startAyahs.isNotEmpty ? startAyahs.first : null,
      },
      'end': {
        'page': endPage,
        'surahs': endSurahs.map((s) => s.name).join(', '),
        'juz': getJuzNames()[endJuzNumber - 1],
        'num_ayahs': endAyahs.length,
        'final_ayah': endAyahs.isNotEmpty ? endAyahs.last : null,
      },
      'first_ayah': startAyahs.isNotEmpty ? startAyahs.first.text : null,
    };
  }

  int _getStartingPageForPortion(int value, Khetma khetma) {
    print("Getting starting page for portion: value=$value, portionType=${khetma.portionType}");
    switch (khetma.portionType) {
      case PortionType.Juz:
        final page = getPageForJuz(value);
        print("Juz $value starts at page $page");
        return page;
      case PortionType.Page:
        print("Page $value is being used");
        return value;
      case PortionType.HizbQuarter:
        final page = getHizbQuarterStartingPage(value);
        print("Hizb Quarter $value starts at page $page");
        return page;
    }
    throw ArgumentError('Invalid portion type');
  }

  // Add these to QuranCubit
  List<Map<String, dynamic>> getKhetmaHistory(Khetma khetma) {
    return khetma.days
        .sublist(0, khetma.currentDayIndex)
        .map((day) => getWerdDetails(khetma, khetma.days.indexOf(day)))
        .toList();
  }

  Map<String, dynamic> getWerdDetails(Khetma khetma, int dayIndex) {
    if (khetma.days.isEmpty || quranData.isEmpty) {
      return {
        'start': {'page': 0, 'surahs': '', 'juz': ''},
        'end': {'page': 0, 'surahs': '', 'juz': ''}
      };
    }

    final clampedIndex = dayIndex.clamp(0, khetma.days.length - 1);
    final currentDay = khetma.days[clampedIndex];

    final startValue = currentDay.start.clamp(1, 604);
    final endValue = currentDay.end.clamp(1, 604);

    final startPage = _getStartingPageForPortion(startValue, khetma);
    final endPage = _getStartingPageForPortion(endValue, khetma);

    final startJuzNumber = (startPage >= 1 && startPage <= 604) ? pageToJuz[startPage - 1] : 1;
    final endJuzNumber = (endPage >= 1 && endPage <= 604) ? pageToJuz[endPage - 1] : 1;

    final startSurahs = getPageSurahs(quran: quranData, pageNo: startPage);
    final endSurahs = getPageSurahs(quran: quranData, pageNo: endPage);

    final startAyahs = getAyahsFromPageNo(quranList: quranData, pageNo: startPage);
    final endAyahs = getAyahsFromPageNo(quranList: quranData, pageNo: endPage);

    return {
      'start': {
        'page': startPage,
        'surahs': startSurahs.map((s) => s.name).join(', '),
        'juz': getJuzNames()[startJuzNumber - 1],
        'num_ayahs': startAyahs.length,
        'first_ayah': startAyahs.isNotEmpty ? startAyahs.first : null,
      },
      'end': {
        'page': endPage,
        'surahs': endSurahs.map((s) => s.name).join(', '),
        'juz': getJuzNames()[endJuzNumber - 1],
        'num_ayahs': endAyahs.length,
        'final_ayah': endAyahs.isNotEmpty ? endAyahs.last : null,
      },
      'first_ayah': startAyahs.isNotEmpty ? startAyahs.first.text : null,
    };
  }

  // In QuranCubit
  Khetma getActiveKhetma() {
    if (khetmaPlans.isEmpty) {
      throw Exception("No active khetma plans");
    }
    return khetmaPlans.firstWhere(
          (k) => k.currentDayIndex < k.days.length,
      orElse: () => khetmaPlans.first,
    );
  }

  List<Map<String, dynamic>> getUpcomingWerdsDetails(Khetma khetma) {
    final upcoming = khetma.days.sublist(khetma.currentDayIndex + 1);
    return upcoming.map((day) => getWerdDetails(khetma, khetma.days.indexOf(day))).toList();
  }


}