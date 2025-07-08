import 'package:flutter/material.dart';
import 'package:zahrah_yulia_rahman_productivity_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  final int workTime = 25;
  final int shortBreak = 5;
  final int longBreak = 20;

  late SharedPreferences prefs;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int myWorkTime = prefs.getInt(WORKTIME) ?? workTime;
    int myShortBreak = prefs.getInt(SHORTBREAK) ?? shortBreak;
    int myLongBreak = prefs.getInt(LONGBREAK) ?? longBreak;
    setState(() {
      txtWork.text = myWorkTime.toString();
      txtShort.text = myShortBreak.toString();
      txtLong.text = myLongBreak.toString();
    });
  }

  void updateSettings(String key, int value) {
    switch (key) {
      case WORKTIME:
        int myWorkTime = prefs.getInt(WORKTIME) ?? workTime;
        myWorkTime += value;
        if (myWorkTime >= 1 && myWorkTime <= 180) {
          prefs.setInt(WORKTIME, myWorkTime);
          setState(() {
            txtWork.text = myWorkTime.toString();
          });
        }
        break;
      case SHORTBREAK:
        int myShort = prefs.getInt(SHORTBREAK) ?? shortBreak;
        myShort += value;
        if (myShort >= 1 && myShort <= 180) {
          prefs.setInt(SHORTBREAK, myShort);
          setState(() {
            txtShort.text = myShort.toString();
          });
        }
        break;
      case LONGBREAK:
        int myLong = prefs.getInt(LONGBREAK) ?? longBreak;
        myLong += value;
        if (myLong >= 1 && myLong <= 180) {
          prefs.setInt(LONGBREAK, myLong);
          setState(() {
            txtLong.text = myLong.toString();
          });
        }
        break;
      default:
    }
  }

  void resetSettings() {
    print('Reset setting called');
    prefs.setInt(WORKTIME, workTime);
    prefs.setInt(SHORTBREAK, shortBreak);
    prefs.setInt(LONGBREAK, longBreak);
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 24,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        childAspectRatio: 3,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(20),
        crossAxisCount: 3,
        children: [
          Text(
            'Work',
            style: textStyle,
          ),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '-',
            value: -1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtWork,
          ),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '+1',
            value: 1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          Text(
            'Short',
            style: textStyle,
          ),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '-',
            value: -1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtShort,
          ),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '+1',
            value: 1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          Text(
            'Long',
            style: textStyle,
          ),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '-',
            value: -1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtLong,
          ),
          SettingsButton(
            color: Colors.indigoAccent,
            text: '+1',
            value: 1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
          const Text(''),
          const Text(''),
          const Text(''),
          const Text(''),
          ElevatedButton(
            onPressed: () => resetSettings(),
            child: Text(
              'Reset',
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }
}