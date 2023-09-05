import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:project_neal/widgets/GraphShow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TopCard extends StatefulWidget {
  const TopCard({super.key});

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  late SharedPreferences prefs;
  double totalElapsedTaka = 0; // Sum of elapsed taka values
  double totalElapsedUnit = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateTotalElapsedTaka();
  }

  Future<void> calculateTotalElapsedTaka() async {
    prefs = await SharedPreferences.getInstance();
    double fanBedElapsedTaka = prefs.getDouble('fanBed_elapsed_taka') ?? 0;
    double fanLivElapsedTaka = prefs.getDouble('fanLiv_elapsed_taka') ?? 0;
    double lightBedElapsedTaka = prefs.getDouble('lightBed_elapsed_taka') ?? 0;
    double lightLivElapsedTaka = prefs.getDouble('lightLiv_elapsed_taka') ?? 0;
    double lightBathElapsedTaka =
        prefs.getDouble('lightBath_elapsed_taka') ?? 0;

    double fanBedElapsedUnit = prefs.getDouble('fanBed_elapsed_unit') ?? 0;
    double fanLivElapsedUnit = prefs.getDouble('fanLiv_elapsed_unit') ?? 0;
    double lightBedElapsedUnit = prefs.getDouble('lightBed_elapsed_unit') ?? 0;
    double lightLivElapsedUnit = prefs.getDouble('lightLiv_elapsed_unit') ?? 0;
    double lightBathElapsedUnit =
        prefs.getDouble('lightBath_elapsed_unit') ?? 0;

// ------------ Printing ------------------------

    print(fanLivElapsedUnit);
    print(fanBedElapsedUnit);
    print(lightBedElapsedUnit);
    print(lightLivElapsedUnit);
    print(lightBathElapsedUnit);

//--------------------------------------

    double totalfan = fanLivElapsedTaka + fanBedElapsedTaka;
    double totalLight =
        lightBathElapsedTaka + lightLivElapsedTaka + lightBedElapsedTaka;
    setState(() {
      totalElapsedTaka = totalfan + totalLight;
      totalElapsedUnit = fanLivElapsedUnit +
          fanBedElapsedUnit +
          lightBathElapsedUnit +
          lightLivElapsedUnit +
          lightBedElapsedUnit;
    });
  }

  void resetValues() {
    setState(() {
      totalElapsedTaka = 0;
      totalElapsedUnit = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0, // Adds a soft shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * .95,
          height: 180.0,
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Energy Usage',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.power_outlined)),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(color: kFontLightGrey),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${totalElapsedUnit.toStringAsFixed(5)} KWh',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Today',
                            style: TextStyle(color: kFontLightGrey),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${totalElapsedTaka.toStringAsFixed(5)} taka',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              30), // Adjust the radius as needed
                          color: kButtonDarkBlue, // Button background color
                        ),
                        // child: ElevatedButton(
                        //   onPressed: resetValues,
                        //   style: ElevatedButton.styleFrom(
                        //     primary: Colors
                        //         .transparent, // Make the button transparent
                        //     elevation: 0, // Remove button elevation
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 10,
                        //         vertical: 2), // Adjust padding as needed
                        //   ),
                        //   child: Text(
                        //     "Reset",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              30), // Adjust the radius as needed
                          color: kButtonDarkBlue, // Button background color
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowGraph(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .transparent, // Make the button transparent
                            elevation: 0, // Remove button elevation
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2), // Adjust padding as needed
                          ),
                          child: Text(
                            "Graph",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      Text(
                        '16 Aug, 2023',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.update)),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This Month',
                            style: TextStyle(color: kFontLightGrey),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '345.56 kWh',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
