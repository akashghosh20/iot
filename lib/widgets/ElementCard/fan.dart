import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database

class Fan extends StatefulWidget {
  const Fan({Key? key}) : super(key: key);

  @override
  State<Fan> createState() => _FanState();
}

class _FanState extends State<Fan> {
  bool isFanOn = false;
  DateTime? startTime;
  Duration elapsedDuration = Duration.zero;
  double? voltage;
  double? current;
  double takaPerUnit = 4.14; // Cost per unit in your currency
  late SharedPreferences prefs;
  late DatabaseReference voltageRef;
  late DatabaseReference currentRef;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    initializeFirebase(); // Initialize Firebase

    // Initialize Firebase Database references
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    voltageRef = databaseReference.child('voltage');
    currentRef = databaseReference.child('current');

    // Listen for changes in voltage and current
    voltageRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          voltage = double.tryParse(event.snapshot.value.toString());
        });
      }
    });

    currentRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          current = double.tryParse(event.snapshot.value.toString());
        });
      }
    });
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadElapsedTime();
  }

  Future<void> saveElapsedTime(Duration duration) async {
    await prefs.setInt('fan_elapsed_duration', duration.inSeconds);
  }

  Future<void> saveElapsedTaka(double taka) async {
    await prefs.setDouble('fan_elapsed_taka', taka);
  }

  void loadElapsedTime() {
    final storedDuration = prefs.getInt('fan_elapsed_duration') ?? 0;
    setState(() {
      elapsedDuration = Duration(seconds: storedDuration);
    });
  }

  void resetCalculations() {
    setState(() {
      elapsedDuration = Duration.zero;
    });

    saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
    saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
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
              calculateElapsedTaka(elapsedDuration, voltage ?? 0, current ?? 0);
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
              'Elapsed Unit: ${calculateElapsedUnit(elapsedDuration, voltage ?? 0, current ?? 0)}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Elapsed Taka: ${calculateElapsedTaka(elapsedDuration, voltage ?? 0, current ?? 0)}',
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

  double calculateElapsedUnit(
      Duration duration, double voltage, double current) {
    double totalHours = duration.inSeconds / 3600;
    double watt = voltage * current * 0.89;
    double kwh = watt / 10000;
    return double.parse(totalHours.toStringAsFixed(4)) * kwh;
  }

  double calculateElapsedTaka(
      Duration duration, double voltage, double current) {
    double watt = voltage * current * 0.89;
    double kwh = watt / 1000;
    double totalHours = duration.inSeconds / 3600;
    return double.parse(totalHours.toStringAsFixed(4)) * kwh * takaPerUnit;
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

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
}
