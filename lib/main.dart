import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasker/screens/auth/login.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tasker_database');

  await Hive.openBox('user_database');

  final userBox = Hive.box('user_database');

  if (userBox.isEmpty) {
    userBox.add({'username': 'admin', 'password': 'admin'});
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
