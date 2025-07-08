import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zahrah_yulia_rahman_productivity_timer/settings.dart';
import 'package:zahrah_yulia_rahman_productivity_timer/timer.dart';
import 'package:zahrah_yulia_rahman_productivity_timer/timermodel.dart';
import 'package:zahrah_yulia_rahman_productivity_timer/widgets.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity Timer',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const TimerHomepage(),
    );
  }
}

class TimerHomepage extends StatefulWidget {
  const TimerHomepage({super.key});

  @override
  State<TimerHomepage> createState() => _TimerHomepageState();
}

class _TimerHomepageState extends State<TimerHomepage> {
  final double defaultPadding = 5.0;

  final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];

  final String SETTINGS = 'Settings';

  String buttonText = '-';

  late TimerModel timerModel;
  late CountDownTimer countDownTimer;

  @override
  void initState() {
    menuItems.add(
      PopupMenuItem(value: SETTINGS, child: const Text('Settings')),
    );
    menuItems.add(const PopupMenuItem(value: 'About', child: Text('About')));
    timerModel = TimerModel(time: '00:00', percent: 1.0);
    countDownTimer = CountDownTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Timer'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == SETTINGS) {
                goToSettings(context);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade900,
                      text: 'Work',
                      onPressed: () {
                        countDownTimer.startWork();
                        setState(() {
                          buttonText = 'Pause';
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade600,
                      text: 'Short Break',
                      onPressed: () {
                        countDownTimer.startBreak(true);
                        setState(() {
                          buttonText = 'Pause';
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade300,
                      text: 'Long Break',
                      onPressed: () {
                        countDownTimer.startBreak(false);
                        setState(() {
                          buttonText = 'Pause';
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                ],
              ),
              StreamBuilder(
                initialData: '00:00',
                stream: countDownTimer.stream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  timerModel =
                      snapshot.data == '00:00' ? timerModel : snapshot.data;

                  return Expanded(
                    child: CircularPercentIndicator(
                      radius: availableWidth / 2.5,
                      lineWidth: 20,
                      percent: timerModel.percent,
                      progressColor: Colors.indigo.shade500,
                      circularStrokeCap: CircularStrokeCap.round,
                      reverse: true,
                      center: Text(
                        timerModel.time,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.blue.shade800,
                      text: buttonText,
                      onPressed: () {
                        if (buttonText != '-') {
                          if (countDownTimer.isActive) {
                            countDownTimer.stopTimer();
                            setState(() {
                              buttonText = 'Resume';
                            });
                          } else {
                            countDownTimer.startTimer();
                            setState(() {
                              buttonText = 'Pause';
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.blue.shade900,
                      text: 'Reset',
                      onPressed: () {
                        countDownTimer.reset();
                        setState(() {
                          buttonText = '-';
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void emptyMethod() {}
}