import 'package:flutter/widgets.dart';

class ResponsiveUtils {

  static const int _minLargeWidth = 950;
  static const int _minMediumWidth = 600;

  static const double _listItemHorizontalPaddingLargeWidth = 132.0;

  static const double _destinationPickerHorizontalMarginMediumScreen = 144.0;
  static const double _destinationPickerVerticalMarginMediumScreen = 234.0;
  static const double _destinationPickerHorizontalMarginLargeScreen = 234.0;
  static const double _destinationPickerVerticalMarginLargeScreen = 144.0;

  static const double _orderByButtonHorizontalPaddingLargeWidth = 155.0;
  static const double _orderByButtonHorizontalPaddingDefault = 16.0;

  static const double _contextMenuHorizontalMargin = 144.0;

  static const double _loginTextBuilderWidthSmallScreen = 280.0;
  static const double _loginTextBuilderWidthLargeScreen = 320.0;

  static const double _loginButtonWidth = 240.0;

  static const double _radiusDestinationPickerView = 20.0;

  double getSizeWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double getSizeHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  bool isLargeScreen(BuildContext context) {
    return getSizeWidthScreen(context) >= _minLargeWidth;
  }

  bool isSmallScreen(BuildContext context) {
    return getSizeWidthScreen(context) < _minMediumWidth;
  }

  bool isMediumScreen(BuildContext context) {
    return getSizeWidthScreen(context) >= _minMediumWidth
      && getSizeWidthScreen(context) < _minLargeWidth;
  }

  EdgeInsets getPaddingListItemForScreen(BuildContext context) {
    return isLargeScreen(context) ? EdgeInsets.symmetric(horizontal: _listItemHorizontalPaddingLargeWidth) : EdgeInsets.zero;
  }

  EdgeInsets getPaddingOrderByButtonForScreen(BuildContext context) {
    return isLargeScreen(context)
      ? EdgeInsets.symmetric(horizontal: _orderByButtonHorizontalPaddingLargeWidth)
      : EdgeInsets.symmetric(horizontal: _orderByButtonHorizontalPaddingDefault);
  }

  EdgeInsets getMarginForDestinationPicker(BuildContext context) {
    if (isMediumScreen(context)) {
      return getSizeHeightScreen(context) <= _destinationPickerVerticalMarginMediumScreen * 2
        ? EdgeInsets.symmetric(
            horizontal: _destinationPickerHorizontalMarginMediumScreen,
            vertical: 0.0)
        : EdgeInsets.symmetric(
            horizontal: _destinationPickerHorizontalMarginMediumScreen,
            vertical: _destinationPickerVerticalMarginMediumScreen);
    } else if (isLargeScreen(context)) {
      return getSizeHeightScreen(context) <= _destinationPickerVerticalMarginLargeScreen * 2
        ? EdgeInsets.symmetric(
            horizontal: _destinationPickerHorizontalMarginLargeScreen,
            vertical: 0.0)
        : EdgeInsets.symmetric(
            horizontal: _destinationPickerHorizontalMarginLargeScreen,
            vertical: _destinationPickerVerticalMarginLargeScreen);
    } else {
      return EdgeInsets.zero;
    }
  }

  BorderRadius getBorderRadiusView(BuildContext context) {
    if (isMediumScreen(context)) {
      return getSizeHeightScreen(context) <= _destinationPickerVerticalMarginMediumScreen * 2
        ? BorderRadius.only(
            topLeft: Radius.circular(_radiusDestinationPickerView),
            topRight: Radius.circular(_radiusDestinationPickerView))
        : BorderRadius.circular(_radiusDestinationPickerView);
    } else if (isLargeScreen(context)) {
      return getSizeHeightScreen(context) <= _destinationPickerVerticalMarginLargeScreen * 2
        ? BorderRadius.only(
            topLeft: Radius.circular(_radiusDestinationPickerView),
            topRight: Radius.circular(_radiusDestinationPickerView))
        : BorderRadius.circular(_radiusDestinationPickerView);
    } else {
      return BorderRadius.zero;
    }
  }

  EdgeInsets getMarginContextMenuForScreen(BuildContext context) {
    return isSmallScreen(context)
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: _contextMenuHorizontalMargin);
  }

  double getWidthLoginTextBuilder(BuildContext context) => isSmallScreen(context)
      ? _loginTextBuilderWidthSmallScreen
      : _loginTextBuilderWidthLargeScreen;

  double getWidthLoginButton() => _loginButtonWidth;
}