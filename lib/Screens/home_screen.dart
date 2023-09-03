import 'package:flutter/material.dart';
import 'package:project_neal/widgets/middle_tabs.dart';
import 'package:project_neal/widgets/top_card.dart';
import 'package:project_neal/widgets/top_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        ),
      ),
    );
  }
}
