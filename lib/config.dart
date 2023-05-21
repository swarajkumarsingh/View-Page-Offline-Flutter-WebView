final config = _Config();

class _Config {
  String applicationName = "Offline Webview";
}

final bool isInProduction = _isDebugModeCustom == false ? false : true;

bool get _isDebugModeCustom {
  bool value = false;
  assert(() {
    value = true;
    return true;
  }());
  return value;
}
