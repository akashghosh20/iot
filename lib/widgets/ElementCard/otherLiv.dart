import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class OtherLiv extends StatefulWidget {
  const OtherLiv({Key? key}) : super(key: key);

  @override
  State<OtherLiv> createState() => _OtherLivState();
}

class _OtherLivState extends State<OtherLiv> with WidgetsBindingObserver {
  bool isLightOn = false;
  DateTime? startTime;
  Duration elapsedDuration = Duration.zero;
  double? voltage = 200;
  double? current;
  double takaPerUnit = 10;
  double elapsedUnitLightliv = 0;
  late SharedPreferences prefs;
  DatabaseReference? databaseReference;
  DatabaseReference? databaseReference2;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    WidgetsBinding.instance.addObserver(this);

    // Initialize the database reference
    databaseReference =
        FirebaseDatabase.instance.reference().child('data').child('1');
    databaseReference2 = FirebaseDatabase.instance.reference();

    // Load current and voltage data from Firebase
    loadCurrentAndVoltage();
    loadIsLightOn(); // Load the initial isLightOn value from the database
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Function to load the initial value of isLightOn from the database
  void loadIsLightOn() {
    databaseReference2 = FirebaseDatabase.instance.ref().child('switches');
    databaseReference2!.child('main').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      final value = snapshot.value;
      if (value is bool) {
        setState(() {
          isLightOn = value;
        });
      }
    }).onError((error) {
      print('Error loading isLightOn from Firebase: $error');
    });
  }

// Function to update the isLightOn value in the database
  void updateIsLightOn(bool newValue) {
    databaseReference2 =
        FirebaseDatabase.instance.reference().child('switches');
    databaseReference2!.update({'main': newValue}).then((_) {
      // Update the UI immediately when the value is updated in the database
      setState(() {
        isLightOn = newValue;
      });
      print('isLightOn updated successfully');
    }).catchError((error) {
      print('Error updating isLightOn: $error');
    });
  }

  // void resetCalculations() {
  //   setState(() {
  //     elapsedDuration = Duration.zero;
  //     elapsedUnitLightliv = 0;
  //   });

  //   saveElapsedTime(Duration.zero); // Reset elapsed time in SharedPreferences
  //   saveElapsedTaka(0); // Reset elapsed taka in SharedPreferences
  //   saveElapsedUnit(0);
  // }

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
        // saveElapsedTime(elapsedDuration);

        // Calculate and save elapsed taka
        double elapsedTaka = calculateElapsedTaka(
            elapsedDuration, voltage! * current! * 0.89 / 1000);
        // saveElapsedTaka(elapsedTaka);
        elapsedUnitLightliv = calculateElapsedUnit(
            elapsedDuration, voltage! * current! * 0.89 / 1000);
        // saveElapsedUnit(elapsedUnitLightliv);
      }
    }
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // loadElapsedTime();
  }

  // void loadElapsedTime() {
  //   final storedDuration = prefs.getInt('lightLiv_elapsed_duration') ?? 0;
  //   setState(() {
  //     elapsedDuration = Duration(seconds: storedDuration);
  //   });
  // }

  // Future<void> saveElapsedTime(Duration duration) async {
  //   await prefs.setInt('lightLiv_elapsed_duration', duration.inSeconds);
  // }

  // Future<void> saveElapsedTaka(double taka) async {
  //   await prefs.setDouble('lightLiv_elapsed_taka', taka);
  // }

  // Future<void> saveElapsedUnit(double unit) async {
  //   await prefs.setDouble('lightLiv_elapsed_unit', unit);
  // }

  void onLightSwitchChanged(bool newValue) {
    setState(() {
      if (newValue) {
        startTime = DateTime.now();
      } else {
        if (startTime != null) {
          final DateTime endTime = DateTime.now();
          elapsedDuration += endTime.difference(startTime!);
          startTime = null;
          // saveElapsedTime(elapsedDuration);

          // Calculate and save elapsed taka
          // double elapsedTaka = calculateElapsedTaka(
          //     elapsedDuration, voltage! * current! * 0.89 / 1000);
          // elapsedUnitLightliv = calculateElapsedUnit(
          //     elapsedDuration, voltage! * current! * 0.89 / 1000);
          // saveElapsedUnit(elapsedUnitLightliv);
          // saveElapsedTaka(elapsedTaka);
        }
      }
      updateIsLightOn(newValue);

      // Update the isLightOn value in the database when the switch changes
      // updateIsLightOn(isLightOn);
    });
  }

  void loadCurrentAndVoltage() {
    if (databaseReference != null) {
      databaseReference!.onValue.listen((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        Map<dynamic, dynamic>? data =
            dataSnapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          // Extract all current values from the data
          List<double> currentValues = [];

          data.forEach((timestamp, values) {
            if (values is Map<dynamic, dynamic> && values.containsKey('amp')) {
              double? currentData = values['amp'] as double?;
              if (currentData != null) {
                currentValues.add(currentData);
              }
            }
          });

          if (currentValues.isNotEmpty) {
            // Calculate the average current value
            double sum = currentValues.reduce((a, b) => a + b);
            double averageCurrent = sum / currentValues.length;

            // Update the state with the average current value
            setState(() {
              current = averageCurrent;
            });
          }
        }
      }, onError: (error) {
        print('Error loading data from Firebase: $error');
      });
    } else {
      print(
          'Database reference is null. Make sure it is properly initialized.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (current == null || voltage == null) {
      // Handle loading or error state
      return CircularProgressIndicator(); // or show an error message
    } else {
      // Data is loaded, display your widget with current and voltage
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
                'Main Switch',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('1 device'),
              customSwitch(isLightOn, onLightSwitchChanged),

              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(30), // Adjust the radius as needed
                  color: kButtonDarkBlue, // Button background color
                ),
                // child: ElevatedButton(
                //   // onPressed: resetCalculations,
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.transparent, // Make the button transparent
                //     elevation: 0, // Remove button elevation
                //     padding: EdgeInsets.symmetric(
                //         horizontal: 20,
                //         vertical: 10), // Adjust padding as needed
                //   ),
                //   child: Text(
                //     "Recalculate",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ),

              // Display voltage value
            ],
          ),
        ),
      );
    }
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double calculateElapsedUnit(Duration duration, double powerKW) {
    double totalHours = duration.inSeconds / 3600;
    return totalHours * powerKW;
  }

  double calculateElapsedTaka(Duration duration, double powerKW) {
    double totalHours = duration.inSeconds / 3600;
    return totalHours * powerKW * takaPerUnit;
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
