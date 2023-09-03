import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';

class LightBed extends StatefulWidget {
  const LightBed({Key? key}) : super(key: key);

  @override
  State<LightBed> createState() => _LightBedState();
}

class _LightBedState extends State<LightBed> with WidgetsBindingObserver {
  bool isLightOn = false;
  DateTime? startTime;
  Duration elapsedDuration = Duration.zero;
  double wattOfLight = 60;
  double takaPerUnit = 10;
  double elapsedLightBed = 0;
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
      elapsedLightBed = 0;
    });

    saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
    saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
    saveElapsedUnit(0);
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

        elapsedLightBed =
            calculateElapsedUnit(elapsedDuration, wattOfLight / 1000);
        saveElapsedUnit(elapsedLightBed);
      }
    }
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadElapsedTime();
  }

  void loadElapsedTime() {
    final storedDuration = prefs.getInt('lightBed_elapsed_duration') ?? 0;
    setState(() {
      elapsedDuration = Duration(seconds: storedDuration);
    });
  }

  Future<void> saveElapsedTime(Duration duration) async {
    await prefs.setInt('lightBed_elapsed_duration', duration.inSeconds);
  }

  Future<void> saveElapsedTaka(double taka) async {
    await prefs.setDouble('lightBed_elapsed_taka', taka);
  }

  Future<void> saveElapsedUnit(double unit) async {
    await prefs.setDouble('lightBed_elapsed_unit', unit);
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
          elapsedLightBed =
              calculateElapsedUnit(elapsedDuration, wattOfLight / 1000);
          saveElapsedUnit(elapsedLightBed);
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
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(30), // Adjust the radius as needed
                color: kButtonDarkBlue, // Button background color
              ),
              child: ElevatedButton(
                onPressed: resetCalculations,
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, // Make the button transparent
                  elevation: 0, // Remove button elevation
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Adjust padding as needed
                ),
                child: Text(
                  "Recalculate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
