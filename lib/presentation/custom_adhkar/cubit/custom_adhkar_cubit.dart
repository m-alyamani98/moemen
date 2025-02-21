
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../../domain/models/adhkar/custom_adhkar_model.dart';
import '../../../domain/usecase/base_usecase.dart';
import '../../../domain/usecase/del_custom_dhikr_by_id_usecase.dart';
import '../../../domain/usecase/get_all_custom_adhkar_usecase.dart';
import '../../../domain/usecase/insert_new_dhikr_usecase.dart';

part 'custom_adhkar_state.dart';

class CustomAdhkarCubit extends Cubit<CustomAdhkarState> {
  final GetAllCustomAdhkarUseCase _getAllCustomAdhkarUseCase =
      instance<GetAllCustomAdhkarUseCase>();
  final InsertNewDhikrUseCase _insertNewDhikrUseCase =
      instance<InsertNewDhikrUseCase>();

  CustomAdhkarCubit() : super(CustomAdhkarInitial());

  static CustomAdhkarCubit get(context) => BlocProvider.of(context);

  bool isBotSheetShown = false;
  IconData fabIcon = Icons.add;

  void changeBotSheetState({
    required bool isShown,
  }) {
    isBotSheetShown = isShown;

    emit(ChangeBotSheetState());
  }

  List<CustomAdhkarEntity> customAdhkar = [];

  Future<void> getAllCustomAdhkar() async {
    emit(GetAllCustomAdhkarLoadingState());
    final result = await _getAllCustomAdhkarUseCase(const NoParameters());
    result.fold((l) {
      emit(GetAllCustomAdhkarErrorState(l.message));
    }, (r) {
      customAdhkar = r;
      emit(GetAllCustomAdhkarSuccessState());
    });
  }

  Future<void> insertNewDhikr(CustomAdhkarEntity dhikr) async {
    emit(InsertNewDhikrLoadingState());
    getAllCustomAdhkar();
    await _insertNewDhikrUseCase(dhikr).then((value) => value.fold((l) {
          emit(InsertNewDhikrErrorState(l.message));
        }, (r) {
          getAllCustomAdhkar();
          emit(InsertNewDhikrSuccessState());
        }));
  }

}
