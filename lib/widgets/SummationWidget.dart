import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummationWidget extends StatefulWidget {
  @override
  _SummationWidgetState createState() => _SummationWidgetState();
}

class _SummationWidgetState extends State<SummationWidget> {
  double totalElapsedTaka = 0; // Sum of elapsed taka values
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    calculateTotalElapsedTaka();
  }

  Future<void> calculateTotalElapsedTaka() async {
    prefs = await SharedPreferences.getInstance();
    double fanElapsedTaka = prefs.getDouble('fan_elapsed_taka') ?? 0;
    double lightElapsedTaka = prefs.getDouble('light_elapsed_taka') ?? 0;

    setState(() {
      totalElapsedTaka = fanElapsedTaka + lightElapsedTaka;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Elapsed Taka',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Sum: $totalElapsedTaka',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
