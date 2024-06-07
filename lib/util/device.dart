import 'dart:io';

import 'package:flutter/foundation.dart';

final class Device {
  Device._();

  static bool isComputer() {
    return kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }
}
