final config = _Config();

class _Config {
  String applicationName = "Offline Webview";
}

final bool isInProduction = isDebugMode == false ? false : true;

bool get isDebugMode {
  bool value = false;
  assert(() {
    value = true;
    return true;
  }());
  return value;
}
