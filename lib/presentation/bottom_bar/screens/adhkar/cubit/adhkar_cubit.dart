import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/utils/constants.dart';
import '../../../../../di/di.dart';
import '../../../../../domain/models/adhkar/adhkar_model.dart';
import '../../../../../domain/usecase/adhkar_usecase.dart';
import '../../../../../domain/usecase/base_usecase.dart';

part 'adhkar_state.dart';

class AdhkarCubit extends Cubit<AdhkarState> {
  final AdhkarUseCase _adhkarUseCase = instance<AdhkarUseCase>();

  AdhkarCubit() : super(AdhkarInitial());

  static AdhkarCubit get(context) => BlocProvider.of(context);

  List<AdhkarModel> adhkarList = [];

  Future getAdhkarData() async {
    emit(AdhkarGetDataLoadingState());
    final result = await _adhkarUseCase(const NoParameters());
    result.fold((l) => emit(AdhkarGetDataErrorState(l.message)),
        (r) {
      adhkarList = r;
          emit(AdhkarGetDataSuccessState(r));
        });
  }

  List<AdhkarModel> getAdhkarFromCategory({
    required List<AdhkarModel> adhkarList,
    required String categoryAr
  }) {
    final filtered = adhkarList.where((e) => e.category['ar'] == categoryAr).toList();
    print('Filtering adhkar: ${filtered.length} items found for category $categoryAr');
    return filtered;
  }


  List<AdhkarCategory> getUniqueCategories(List<AdhkarModel> adhkarList) {
    Map<String, IconData> categoryMap = {};
    for (var adhkar in adhkarList) {
      final arCategory = adhkar.category['ar'] ?? '';
      if (!categoryMap.containsKey(arCategory)) {
        categoryMap[arCategory] = adhkar.icon;
      }
    }
    return categoryMap.entries
        .map((e) => AdhkarCategory(name: e.key, icon: e.value))
        .toList();
  }



List<String> getAdhkarCategories(
      {required List<AdhkarModel> adhkarList,}) {
    List<String> adhkarCategories =
    List.from(adhkarList.map((e) => e.category).toSet());
    return adhkarCategories;
  }

  int count = 0;

  void dhikrCounter(int maxCounts, PageController controller) {
    if (count < maxCounts) {
      count++;
    }
    if (count == maxCounts) {
      controller.nextPage(
          curve: Curves.ease,
          duration: const Duration(milliseconds: Constants.nextPageDuration));
    }
    controller.addListener(() {
      count = 0;
    });

    emit(AdhkarCounterState());
  }

  void customDhikrCounter(int maxCounts) {
    if (count < maxCounts) {
      count++;
    }

    emit(AdhkarCounterState());
  }

  void resetCounter(){
    count = 0;
    emit(AdhkarCounterResetState());
  }
}

class AdhkarCategory {
  final String name;
  final IconData icon;

  AdhkarCategory({required this.name, required this.icon});
}
