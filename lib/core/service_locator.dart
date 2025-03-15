import 'package:get_it/get_it.dart';
import 'package:moemen/presentation/bottom_bar/viewmodel/home_viewmodel.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
}
