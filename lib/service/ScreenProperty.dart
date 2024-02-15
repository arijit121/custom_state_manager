import 'package:flutter/material.dart';

import '../main.dart';

class ScreenProperty {
  static BuildContext getCurrentContext() {
    return navigatorKey.currentContext!;
  }
}
