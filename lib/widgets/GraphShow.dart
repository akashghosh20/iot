import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowGraph extends StatefulWidget {
  ShowGraph({Key? key}) : super(key: key);

  @override
  _ShowGraphState createState() => _ShowGraphState();
}

double totalElapsedTaka = 0;

class _ShowGraphState extends State<ShowGraph> {
  List<_SalesData> data = [
    _SalesData('Jan', 0),
    _SalesData('Feb', 0),
    _SalesData('Mar', 0),
    _SalesData('Apr', 0),
    _SalesData('May', 0),
    _SalesData('June', 0),
    _SalesData('July', 0),
    _SalesData('August', 0),
    _SalesData('Sep', totalElapsedTaka),
    _SalesData('Oct', 0),
    _SalesData('Nov', 0),
    _SalesData('Dec', 0),
  ];

  @override
  void initState() {
    super.initState();
    loadTotalElapsedTaka(); // Load the totalElapsedTaka value from SharedPreferences
  }

  Future<void> loadTotalElapsedTaka() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalElapsedTaka = prefs.getDouble('total_elapsed_taka') ?? 0;
      // Update the data with the loaded totalElapsedTaka value
      data[8].sales =
          totalElapsedTaka; // Assuming 'Sep' corresponds to the 9th data point
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kButtonDarkBlue,
        title: const Text('Graph'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: SizedBox(
          width: 1000, // Set a fixed width for the chart area
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'KWh Analysis'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),

            series: <ChartSeries<_SalesData, String>>[
              // Series with primary Y-axis
              LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'KWh ',
                yAxisName: 'primaryYAxis',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  double sales;
}
