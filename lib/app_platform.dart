import 'package:flutter/foundation.dart';
import 'dart:io';

class AppPlatform {
  static const Map<String, CustomPlatform> _platfromMap = {
    'linux': CustomPlatform.linux,
    'macos': CustomPlatform.macos,
    'windows': CustomPlatform.windows,
    'android': CustomPlatform.android,
    'ios': CustomPlatform.ios,
    'fuchsia': CustomPlatform.fuchsia,
  };

  static bool isMobile() {
    var platformIs = _getPlatform();

    if (platformIs == CustomPlatform.ios ||
        platformIs == CustomPlatform.android) {
      return true;
    } else {
      return false;
    }
  }

  static CustomPlatform? _getPlatform() {
    if (kIsWeb) {
      return CustomPlatform.web;
    }

    return _platfromMap[Platform.operatingSystem] ?? CustomPlatform.undefined;
  }

  static CustomPlatform? get platform => _getPlatform();
}

enum CustomPlatform {
  linux,
  macos,
  windows,
  ios,
  android,
  fuchsia,
  web,
  undefined,
}
