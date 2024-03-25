///
///
///
String durationToTimeFormat(Duration duration) {
  //*NOTE: ref: (https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss)
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  List<String> timeFormat = [];
  if (duration.inHours > 0) {
    timeFormat.add(duration.inHours.toString());
  } else {
    timeFormat.addAll([twoDigitMinutes, twoDigitSeconds]);
  }

  return timeFormat.join(':');
}
