import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';

class Laptop extends StatefulWidget {
  const Laptop({super.key});

  @override
  State<Laptop> createState() => _LaptopState();
}

class _LaptopState extends State<Laptop> {
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
            Icon(Icons.laptop),
            Text(
              'Laptop Charger',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('1 device'),
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
