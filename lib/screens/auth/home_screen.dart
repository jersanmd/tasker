import 'package:flutter/material.dart';
import 'package:tasker/constants/app.dart';
import 'package:tasker/widgets/app_bar.dart';
import 'package:tasker/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBarWidget(appBar: AppBar(), title: 'Home'),
      body: const SafeArea(
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenPadding),
            child: Column(
              children: [],
            ),
          ),
        )),
      ),
    );
  }
}
