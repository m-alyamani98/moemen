import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/resources/resources.dart';


Widget _buildIconCard(String title, IconData icon) {

  return Card(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

Widget getSubTitle(
    {required String settingName, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p12.h, vertical: AppPadding.p5.h),
    child: Text(
      settingName,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppSize.s12.sp,
            wordSpacing: AppSize.s3.w,
            letterSpacing: AppSize.s0_5.w,
            color: ColorManager.iconPrimary,
          ),
    ),
  );
}

Widget getTitle({required String settingName, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p12.h, vertical: AppPadding.p5.h),
    child: Text(
      settingName,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppSize.s14.sp,
            wordSpacing: AppSize.s3.w,
            letterSpacing: AppSize.s0_5.w,
            color: ColorManager.lightGrey,
          ),
    ),
  );
}

Widget settingIndexItem({
  required String? svgPath,
  required IconData? icon,
  required Color color,
  required double angel,
  required String settingName,
  required Widget? trailing,
  required Function onTap,
  required BuildContext context,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: AppPadding.p0.h),
    child: ListTile(
      leading: Padding(
        padding: EdgeInsets.only(top: AppPadding.p0.h),
        child: Transform.rotate(
          angle: angel, // Rotation angle for SVG or icon
          child: svgPath != null
              ? SvgPicture.asset(
                  svgPath,
                  width: 22,
                  height: 22,
                )
              : Icon(
                  icon,
                  size: 22,
                  color: color,
                ),
        ),
      ),
      title: Text(
        settingName,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppSize.s14.sp,
              wordSpacing: AppSize.s3.w,
              letterSpacing: AppSize.s0_5.w,
            ),
      ),
      trailing: trailing,
      onTap: () {
        onTap();
      },
    ),
  );
}

class Dropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double width;

  const Dropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.accentGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: AppSize.s40.r,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        style: TextStyle(
          fontSize: AppSize.s14.r,
          color: ColorManager.textPrimary,
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: ColorManager.iconPrimary,
          size: AppSize.s20.r,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SwitchTileWidget extends StatefulWidget {
  IconData? icon;
  Color color;
  double angel;
  String settingName;
  Function onTap;
  BuildContext context;
  bool isSwitched;

  SwitchTileWidget({
    Key? key,
    this.icon = Icons.settings,
    this.color = Colors.black,
    this.angel = 0.0,
    required this.settingName,
    required this.onTap,
    required this.context,
    required this.isSwitched,
  }) : super(key: key);


  @override
  _SwitchTileWidgetState createState() {
    return _SwitchTileWidgetState();
  }
}

class _SwitchTileWidgetState extends State<SwitchTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p12.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppPadding.p0.h),
            child: Transform.rotate(
              angle: widget.angel, // Rotation angle for SVG or icon
              child: Icon(
                widget.icon,
                size: 22,
                color: widget.color,
              ),
            ),
          ),
          const Spacer(flex: 1),
          Text(
            widget.settingName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSize.s14.sp,
                  wordSpacing: AppSize.s3.w,
                  letterSpacing: AppSize.s0_5.w,
                ),
          ),
          const Spacer(flex: 5),
          InkWell(
            onTap: () {
              widget.onTap();
            },
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    activeColor: ColorManager.primary,
                    activeTrackColor: ColorManager.inactiveColor,
                    inactiveThumbColor: ColorManager
                        .iconPrimary, // Color of the thumb when inactive
                    inactiveTrackColor: ColorManager.inactiveColor,
                    value: widget.isSwitched,
                    onChanged: (value) {
                      setState(() {
                        widget.isSwitched = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconButtonWidget extends StatefulWidget {
  final IconData? icon;
  final VoidCallback onTap;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  _IconButtonWidgetState createState() {
    return _IconButtonWidgetState();
  }
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  int duration = 26;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p5.h),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: ColorManager.secondGrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Center(
            child: Icon(
              widget.icon,
              color: ColorManager.iconPrimary,
              size: AppSize.s20.r,
            ),
          ),
        ),
      ),
    );
  }
}


class Collapsible extends StatefulWidget {
  @override
  CollapsibleWidget createState() => CollapsibleWidget();
}

class CollapsibleWidget extends State<Collapsible> {
  bool isVisible = true;

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() { isVisible = !isVisible; }); },
        child: Container(
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: Opacity(
            opacity: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Visibility(
                    visible: isVisible,
                    child: Container(
                      color: ColorManager.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "surahName",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                                ),
                                Text(
                                  "صفحة ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => (),
                            icon: SvgPicture.asset(
                              'assets/images/logoico.svg',
                              width: AppSize.s35.r,
                              height: AppSize.s35.r,
                            ),
                          ),
                        ],
                      ),
                    ), ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}