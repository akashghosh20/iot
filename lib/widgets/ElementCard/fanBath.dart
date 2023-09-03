import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';

class FanBath extends StatefulWidget {
  const FanBath({Key? key}) : super(key: key);

  @override
  State<FanBath> createState() => _FanBathState();
}

class _FanBathState extends State<FanBath> {
  bool isFanOn = false;
  DateTime? startTime;
  Duration elapsedDuration = Duration.zero;
  double wattOfFan = 75; // Assuming the fan power consumption in watts
  double takaPerUnit = 10; // Cost per unit in your currency
  double elapsedUnitFanBath = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadElapsedTime();
  }

  void loadElapsedTime() {
    final storedDuration = prefs.getInt('fanBath_elapsed_duration') ?? 0;
    setState(() {
      elapsedDuration = Duration(seconds: storedDuration);
    });
  }

  Future<void> saveElapsedTime(Duration duration) async {
    await prefs.setInt('fanBath_elapsed_duration', duration.inSeconds);
  }

  Future<void> saveElapsedTaka(double taka) async {
    await prefs.setDouble('fanBath_elapsed_taka', taka);
  }

  Future<void> saveElapsedUnit(double unit) async {
    await prefs.setDouble('fanBath_elapsed_unit', unit);
  }

  // void resetCalculations() {
  //   setState(() {
  //     elapsedDuration = Duration.zero;
  //     elapsedUnitFanBath = 0;
  //   });

  //   saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
  //   saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
  //   saveElapsedUnit(0);
  // }
  void resetCalculations() {
    setState(() {
      elapsedDuration = Duration.zero;
      elapsedUnitFanBath = 0;
    });

    saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
    saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
    saveElapsedUnit(0); // Reset elapsed unit in SharedPreferences
  }

  void onFanSwitchChanged(bool newValue) {
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
              calculateElapsedTaka(elapsedDuration, wattOfFan / 1000);
          double elapsedUnitFanBath =
              calculateElapsedUnit(elapsedDuration, wattOfFan / 1000);
          saveElapsedUnit(elapsedUnitFanBath);
          saveElapsedTaka(elapsedTaka);
        }
      }
      isFanOn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 150,
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.recycling),
            Text(
              'Fan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('1 device'),
            customSwitch(isFanOn, onFanSwitchChanged),
            Text(
              'Elapsed Time: ${formatDuration(elapsedDuration)}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Elapsed Unit: ${calculateElapsedUnit(elapsedDuration, wattOfFan / 1000)}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Elapsed Taka: ${calculateElapsedTaka(elapsedDuration, wattOfFan / 1000)}',
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
            onChanged: (newValue) {
              onChangedMethod(newValue);
            },
          ),
        ],
      ),
    );
  }
}
