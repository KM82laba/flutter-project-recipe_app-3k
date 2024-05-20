import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData; // Use late keyword to defer initialization
  static late double screenWidth; // Use late keyword to defer initialization
  static double screenHeight = 0; // Initialize with a default value to satisfy non-nullable requirement
  static double defaultSize = 0; // Initialize with a default value to satisfy non-nullable requirement
  static Orientation orientation = Orientation.portrait; // Initialize with a default value to satisfy non-nullable requirement

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}
