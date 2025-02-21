part of 'quran_cubit.dart';

abstract class QuranState {
  const QuranState();
}

class QuranInitial extends QuranState {}

class QuranGetDataLoadingState extends QuranState {}

class QuranGetDataSuccessState extends QuranState {
  final List<QuranModel> quranList;

  const QuranGetDataSuccessState(this.quranList);
}

class QuranGetDataErrorState extends QuranState {
  final String error;

  const QuranGetDataErrorState(this.error);
}

class QuranSearchGetDataLoadingState extends QuranState {}

class QuranSearchGetDataSuccessState extends QuranState {
  final List<QuranSearchModel> quranList;

  const QuranSearchGetDataSuccessState(this.quranList);
}

class QuranSearchGetDataErrorState extends QuranState {
  final String error;

  const QuranSearchGetDataErrorState(this.error);
}

class KhetmaCreatedState extends QuranState {
  final Khetma khetma;
  const KhetmaCreatedState(this.khetma);
}

class QuranErrorState extends QuranState {
  final String message;
  const QuranErrorState(this.message);
}

class KhetmaUpdatedState extends QuranState {
  final Khetma khetma;
  const KhetmaUpdatedState(this.khetma);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KhetmaUpdatedState &&
            runtimeType == other.runtimeType &&
            khetma.name == other.khetma.name &&
            khetma.currentDayIndex == other.khetma.currentDayIndex &&
            listEquals(khetma.days, other.khetma.days);
  }

  @override
  int get hashCode =>
      khetma.name.hashCode ^
      khetma.currentDayIndex.hashCode ^
      khetma.days.hashCode;
}

class KhetmaFinishedState extends QuranState {
  final Khetma finishedKhetma;

  KhetmaFinishedState(this.finishedKhetma);

  @override
  List<Object?> get props => [finishedKhetma];
}