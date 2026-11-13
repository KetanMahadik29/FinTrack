import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

enum DeviceScreenType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  static DeviceScreenType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= AppDimensions.tabletBreakpoint) {
      return DeviceScreenType.desktop;
    } else if (width >= AppDimensions.mobileBreakpoint) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.mobile;
    }
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppDimensions.mobileBreakpoint &&
        width < AppDimensions.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.tabletBreakpoint;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceScreenType.desktop:
        return desktop;
      case DeviceScreenType.tablet:
        return tablet ?? desktop;
      case DeviceScreenType.mobile:
        return mobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = getDeviceType(context);
        return builder(context, screenType);
      },
    );
  }
}
