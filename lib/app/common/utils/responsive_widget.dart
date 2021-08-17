import 'package:cloudreve/app/common/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget? largeScreen;
  final Widget mediumScreen;
  final Widget? smallScreen;

  final ResponsiveUtils responsiveUtil;

  const ResponsiveWidget({
    Key? key,
    this.largeScreen,
    required this.mediumScreen,
    this.smallScreen,
    required this.responsiveUtil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (responsiveUtil.isLargeScreen(context)) {
        return largeScreen ?? mediumScreen;
      } else if (responsiveUtil.isMediumScreen(context)) {
        return mediumScreen;
      } else {
        return smallScreen ?? mediumScreen;
      }
    });
  }
}