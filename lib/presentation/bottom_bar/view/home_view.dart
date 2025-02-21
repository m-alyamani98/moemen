import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momen/core/service_locator.dart';
import 'package:momen/presentation/qibla/view/qiblah_screen.dart';
import '../../../di/di.dart';
import '../../../../../app/resources/resources.dart';
import '../cubit/bottom_bar_cubit.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel _viewModel = instance<HomeViewModel>();
  final homeViewModel = sl<HomeViewModel>();


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
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                _viewModel.titles[currentIndex],
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: ColorManager.primary),
              ),
              leading: IconButton(
                onPressed: () => (Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QiblahScreen(), // Replace with the page you want to navigate to
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
                  label: AppStrings.home.tr(),
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
                  label: AppStrings.werd.tr(),
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
                  label: AppStrings.fahras.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FluentIcons.settings_48_regular),
                  activeIcon: const Icon(FluentIcons.settings_48_filled),
                  label: AppStrings.settings.tr(),
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
