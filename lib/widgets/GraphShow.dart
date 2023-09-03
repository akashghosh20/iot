import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShowGraph extends StatefulWidget {
  ShowGraph({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowGraph> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
    _SalesData('June', 40),
    _SalesData('July', 40),
    _SalesData('August', 40),
    _SalesData('Sep', 40),
    _SalesData('Oct', 40),
    _SalesData('Nov', 40),
    _SalesData('Dec', 40),
  ];

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
  final double sales;
}
