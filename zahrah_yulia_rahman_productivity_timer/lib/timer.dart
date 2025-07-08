import 'dart:async';

import 'package:zahrah_yulia_rahman_productivity_timer/timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool isActive = false;
  Timer? timer;
  Duration _time = const Duration(minutes: 0);
  Duration _fullTime = const Duration(minutes: 0);

  int work = 25;
  int shortBreak = 5;
  int longBreak = 20;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt(WORKTIME) ?? work;
    shortBreak = prefs.getInt(SHORTBREAK) ?? shortBreak;
    longBreak = prefs.getInt(LONGBREAK) ?? longBreak;
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: work);
    _fullTime = _time;
    isActive = true;
  }

  void startBreak(bool isShort) async {
    await readSettings();
    _radius = 1;
    _time = Duration(
      minutes: isShort ? shortBreak : longBreak,
    );
    _fullTime = _time;
    isActive = true;
  }

  void stopTimer() {
    isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      isActive = true;
    }
  }

  String returnTime(Duration t) {
    String minutes = t.inMinutes < 10 ? '0${t.inMinutes}' : '${t.inMinutes}';
    int numSeconds = t.inSeconds - (t.inMinutes * 60); // 90 - (1 * 60) = 30
    String seconds = numSeconds < 10 ? '0$numSeconds' : '$numSeconds';
    return '$minutes:$seconds';
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int a) {
      String time;
      if (isActive) {
        _time = _time - const Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time: time, percent: _radius);
    });
  }

  void reset() {
    _time = const Duration(seconds: 0);
    _radius = 1;
    isActive = false;
  }
}