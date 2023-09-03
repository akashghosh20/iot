import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  State<Light> createState() => _LightState();
}

class _LightState extends State<Light> with WidgetsBindingObserver {
  bool isLightOn = false;
  DateTime? startTime;
  Duration elapsedDuration = Duration.zero;
  double wattOfLight = 60;
  double takaPerUnit = 10;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void resetCalculations() {
    setState(() {
      elapsedDuration = Duration.zero;
    });

    saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
    saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (isLightOn) {
        // Save the elapsed time when app is paused or inactive
        startTime = DateTime.now();
      }
    } else if (state == AppLifecycleState.resumed) {
      // Restore elapsed time when app is resumed
      if (startTime != null) {
        final DateTime endTime = DateTime.now();
        elapsedDuration += endTime.difference(startTime!);
        startTime = null;
        saveElapsedTime(elapsedDuration);

        // Calculate and save elapsed taka
        double elapsedTaka =
            calculateElapsedTaka(elapsedDuration, wattOfLight / 1000);
        saveElapsedTaka(elapsedTaka);
      }
    }
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadElapsedTime();
  }

  void loadElapsedTime() {
    final storedDuration = prefs.getInt('light_elapsed_duration') ?? 0;
    setState(() {
      elapsedDuration = Duration(seconds: storedDuration);
    });
  }
  // void loadElapsedUnit() {
  //   final storedUnit = prefs.getInt('light_elapsed_unit') ?? 0;
  //   setState(() {
  //     elapsedDuration = Duration(seconds: storedDuration);
  //   });
  // }

  Future<void> saveElapsedTime(Duration duration) async {
    await prefs.setInt('light_elapsed_duration', duration.inSeconds);
  }

  Future<void> saveElapsedTaka(double taka) async {
    await prefs.setDouble('light_elapsed_taka', taka);
  }

  void onLightSwitchChanged(bool newValue) {
    setState(() {
      if (newValue) {
        startTime = DateTime.now();
      } else {
        if (startTime != null) {
          final DateTime endTime = DateTime.now();
          elapsedDuration += endTime.difference(startTime!);
          startTime = null;
          saveElapsedTime(elapsedDuration);

          // Calculate and save elapsed taka
          double elapsedTaka =
              calculateElapsedTaka(elapsedDuration, wattOfLight / 1000);
          saveElapsedTaka(elapsedTaka);
        }
      }
      isLightOn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 150,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb),
            Text(
              'Light',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('1 device'),
            customSwitch(isLightOn, onLightSwitchChanged),
            Text(
              'Elapsed Time: ${formatDuration(elapsedDuration)}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Elapsed Unit: ${calculateElapsedUnit(elapsedDuration, wattOfLight / 1000)}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Elapsed Taka: ${calculateElapsedTaka(elapsedDuration, wattOfLight / 1000)}',
              style: TextStyle(fontSize: 12),
            ),
            ElevatedButton(
              onPressed: resetCalculations,
              child: Text('Recalculate'),
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double calculateElapsedUnit(Duration duration, double powerKW) {
    double totalHours = duration.inSeconds / 3600;
    return double.parse(totalHours.toStringAsFixed(4)) * powerKW;
  }

  double calculateElapsedTaka(Duration duration, double powerKW) {
    double totalHours = duration.inSeconds / 3600;
    return double.parse(totalHours.toStringAsFixed(4)) * powerKW * takaPerUnit;
  }

  Widget customSwitch(bool value, Function onChangedMethod) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        left: 26,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoSwitch(
            trackColor: kFontLightGrey,
            activeColor: kButtonDarkBlue,
            value: value,
            onChanged: (newVal) {
              onChangedMethod(newVal);
            },
          ),
        ],
      ),
    );
  }
}
