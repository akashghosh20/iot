import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';

class BedRoom extends StatefulWidget {
  const BedRoom({super.key});

  @override
  State<BedRoom> createState() => _BedRoomState();
}

class _BedRoomState extends State<BedRoom> {
  bool val1 = true;
  onChangedMethod1(bool newVal1) {
    setState(() {
      val1 = newVal1;
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
            Icon(Icons.bedroom_parent_outlined),
            Text(
              'Bedroom',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('3 device'),
            customSwich(val1, onChangedMethod1),
          ],
        ),
      ),
    );
  }

  Widget customSwich(bool val, Function onChangedMethod) {
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
              value: val,
              onChanged: (newVal) {
                onChangedMethod(newVal);
              })
        ],
      ),
    );
  }
}
