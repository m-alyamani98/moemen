import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moemen/core/service_locator.dart';
import 'package:moemen/presentation/qibla/view/qiblah_screen.dart';
import '../../../di/di.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/bottom_bar_cubit.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel _viewModel = instance<HomeViewModel>();
  final homeViewModel = sl<HomeViewModel>();
  final HomeViewModel viewModel = Get.find<HomeViewModel>();


  HomeView({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => instance<HomeCubit>()..isThereABookMarked(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          int currentIndex = cubit.currentIndex;
          final currentLocale = context.locale;
          bool isEnglish =
              currentLocale.languageCode == LanguageType.english.getValue();
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Obx(() {
                  if (currentIndex == 0) {
                    return Text(viewModel.locationTitle.value.isEmpty
                        ? StringTranslateExtension(AppStrings.home).tr()
                        : isEnglish ?  viewModel.locationTitle.value : viewModel.arabicLocationTitle.value);
                  } else if (currentIndex == 1) {
                    return Text(StringTranslateExtension(AppStrings.werd).tr());
                  } else if (currentIndex == 2){
                    return Text(StringTranslateExtension(AppStrings.fahras).tr());
                  }else {
                    return Text(StringTranslateExtension(AppStrings.settings).tr());
                  }
                }),
                leading: IconButton(
                  onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QiblahScreen(),
                    ),
                  ),),
                  icon: SvgPicture.asset(
                    'assets/images/compass.svg',
                    width: AppSize.s20.r,
                    height: AppSize.s20.r,
                  ),
                ),
                actions:[
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/logoico.svg',
                      width: AppSize.s20.r,
                      height: AppSize.s20.r,
                    ),
                  )
                ]
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: ColorManager.primary,
              selectedIconTheme:
              IconThemeData(color: ColorManager.primary, size: AppSize.s20.r),
              selectedLabelStyle: getSemiBoldStyle(color: ColorManager.primary,fontSize: FontSize.s14),
              unselectedLabelStyle: getRegularStyle(color: ColorManager.iconPrimary,fontSize: FontSize.s12),
              unselectedItemColor: ColorManager.bottombarUnSellected,
              unselectedIconTheme: IconThemeData(
                  color: ColorManager.bottombarUnSellected,
                  size: AppSize.s20.r),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              enableFeedback: true,
              currentIndex: currentIndex,
              onTap: (int index) {
                cubit.changeBotNavIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(FluentIcons.home_48_regular),
                  activeIcon: const Icon(FluentIcons.home_48_filled),
                  label: StringTranslateExtension(AppStrings.home).tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/bookr.svg',
                    width: AppSize.s20.r,
                    height: AppSize.s20.r,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/bookf.svg',
                    width: AppSize.s20.r,
                    height: AppSize.s20.r,
                  ),
                  label: StringTranslateExtension(AppStrings.werd).tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/listr.svg',
                    width: AppSize.s20.r,
                    height: AppSize.s20.r,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/listf.svg',
                    width: AppSize.s20.r,
                    height: AppSize.s20.r,
                  ),
                  label: StringTranslateExtension(AppStrings.fahras).tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FluentIcons.settings_48_regular),
                  activeIcon: const Icon(FluentIcons.settings_48_filled),
                  label: StringTranslateExtension(AppStrings.settings).tr(),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w),
              child: _viewModel.screens[currentIndex],
            ),
          );
        },
      ),
    );
  }
}