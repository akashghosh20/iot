import 'package:flutter/material.dart';
import 'package:project_neal/widgets/middle_tabs.dart';
import 'package:project_neal/widgets/top_card.dart';
import 'package:project_neal/widgets/top_header.dart';

class SmartScreen extends StatefulWidget {
  const SmartScreen({super.key});

  @override
  State<SmartScreen> createState() => _SmartScreenState();
}

class _SmartScreenState extends State<SmartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopHeader(),
          TopCard(),
          MiddleTabs(),
        ],
      )),
    );
  }
}
