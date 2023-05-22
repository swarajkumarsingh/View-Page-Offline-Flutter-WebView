final dateHelper = DateHelper();

class DateHelper {
  String getUnixTimeStamp() {
    DateTime now = DateTime.now();
    int unixTimestamp = now.millisecondsSinceEpoch;
    return unixTimestamp.toString();
  }
}
