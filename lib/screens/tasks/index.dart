import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:tasker/constants/app.dart';
import 'package:tasker/widgets/app_bar.dart';

class TaskIndexScreen extends StatefulWidget {
  const TaskIndexScreen({super.key});

  @override
  State<TaskIndexScreen> createState() => _TaskIndexScreenState();
}

class _TaskIndexScreenState extends State<TaskIndexScreen> {
  List<Map<String, dynamic>> _tasks = [
    {
      'name': 'Mangluto',
      'description': 'Lami na manok.',
    },
    {
      'name': 'Manilhig',
      'description': 'Tanggal ug abog.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBar: AppBar(),
        title: 'Tasks',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(
          BootstrapIcons.plus,
          color: AppConstants.backgroundColor,
        ),
        onPressed: () {},
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_tasks[index]['name']),
                    subtitle: Text(_tasks[index]['description']),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: _tasks.length),
          ),
        ),
      ),
    );
  }
}
