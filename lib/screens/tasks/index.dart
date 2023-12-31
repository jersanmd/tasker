import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_alert/status_alert.dart';
import 'package:tasker/constants/app.dart';
import 'package:tasker/widgets/app_bar.dart';
import 'package:tasker/widgets/elevated_button.dart';
import 'package:tasker/widgets/text_field.dart';
import 'package:http/http.dart' as http;

class TaskIndexScreen extends StatefulWidget {
  const TaskIndexScreen({super.key});

  @override
  State<TaskIndexScreen> createState() => _TaskIndexScreenState();
}

class _TaskIndexScreenState extends State<TaskIndexScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _taskNameEditingController =
      TextEditingController();
  final TextEditingController _taskDescriptionEditingController =
      TextEditingController();

  bool isEdit = false;
  int editIndex = 0;

  // List<Map<String, dynamic>> _tasks = [];
  final Box<dynamic> _taskerBox = Hive.box("tasker_database");

  String message = "";
  List<dynamic> _tasks = [];

  // void _refreshTasks() {
  //   final task = _taskerBox.keys.map((key) {
  //     final task = _taskerBox.get(key);

  //     return {
  //       'key': key,
  //       'name': task['name'],
  //       'description': task['description']
  //     };
  //   }).toList();

  //   setState(() {
  //     _tasks = task.reversed.toList();
  //   });
  // }

  Future<void> _refreshTaskApi() async {
    var response = await http.get(
      Uri.parse('http://192.168.99.213:8000/api/tasks'),
    );

    switch (response.statusCode) {
      case 200:
        var body = json.decode(response.body);

        setState(() {
          _tasks = body['tasks'];
        });

        break;
    }
  }

  // Future<void> _storeTask(Map<String, dynamic> task) async {
  //   await _taskerBox.add(task);
  //   _refreshTasks();

  //   _taskNameEditingController.text = "";
  //   _taskDescriptionEditingController.text = "";
  // }

  Future<void> _storeTaskApi(dynamic task) async {
    var response = await http.post(
      Uri.parse('http://192.168.99.213:8000/api/tasks/store'),
      headers: {'Content-type': 'application/x-www-form-urlencoded'},
      body: task,
    );

    switch (response.statusCode) {
      case 200:
        var body = json.decode(response.body);

        setState(() {
          message = body['message'];
        });

        _refreshTaskApi();
        break;
    }
  }

  // Future<void> _updateTask(int key, Map<String, dynamic> task) async {
  //   await _taskerBox.put(key, task);
  //   _refreshTaskApi();

  //   _taskNameEditingController.text = "";
  //   _taskDescriptionEditingController.text = "";
  // }

  Future<void> _updateTaskApi(int index, dynamic task) async {
    var response = await http.patch(
      Uri.parse(
          'http://192.168.99.213:8000/api/tasks/update/${_tasks[index]['id']}'),
      headers: {'Content-type': 'application/x-www-form-urlencoded'},
      body: task,
    );

    switch (response.statusCode) {
      case 200:
        var body = json.decode(response.body);

        setState(() {
          message = body['message'];
        });

        _refreshTaskApi();
        break;
    }
  }

  Future<void> _deleteTaskApi(int index) async {
    var response = await http.delete(Uri.parse(
        'http://192.168.99.213:8000/api/tasks/destroy/${_tasks[index]['id']}'));

    switch (response.statusCode) {
      case 200:
        var body = json.decode(response.body);

        setState(() {
          message = body['message'];
        });

        _refreshTaskApi();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshTaskApi();
  }

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
        onPressed: () {
          isEdit = false;
          _taskNameEditingController.text = "";
          _taskDescriptionEditingController.text = "";
          _createEditTask(context);
        },
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            icon: BootstrapIcons.pencil_fill,
                            foregroundColor: AppConstants.primaryColor,
                            onPressed: (context) {
                              isEdit = true;
                              editIndex = index;
                              setState(() {
                                _taskNameEditingController.text =
                                    _tasks[index]['name'];
                                _taskDescriptionEditingController.text =
                                    _tasks[index]['description'];
                                _createEditTask(context);
                              });
                            },
                          ),
                          SlidableAction(
                            icon: BootstrapIcons.trash_fill,
                            foregroundColor: AppConstants.primaryColor,
                            onPressed: (context) async {
                              await _deleteTaskApi(index).whenComplete(() {
                                _showStatus('Task', 'Task deleted.',
                                    BootstrapIcons.trash_fill);
                              }).onError((error, stackTrace) {
                                _showStatus('Failed', 'Task failed to delete.',
                                    BootstrapIcons.trash_fill);
                              });
                            },
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(_tasks[index]['name']),
                        subtitle: Text(_tasks[index]['description']),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: _tasks.length),
          ),
        ),
      ),
    );
  }

  void _createEditTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Task" : 'Create task'),
          content: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                    name: 'name',
                    labelText: "Name",
                    isObscure: false,
                    textInputType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    controller: _taskNameEditingController,
                  ),
                  const SizedBox(height: AppConstants.textFieldPadding),
                  TextFieldWidget(
                    name: 'description',
                    labelText: "Description",
                    isObscure: false,
                    textInputType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.done,
                    maxLines: 4,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    controller: _taskDescriptionEditingController,
                  ),
                  const SizedBox(height: AppConstants.textFieldPadding),
                  ElevatedButtonWidget(
                    label: isEdit ? "Update" : "Create",
                    buttonColor: AppConstants.primaryColor,
                    buttonTextColor: AppConstants.backgroundColor,
                    icon: isEdit ? BootstrapIcons.pencil : BootstrapIcons.plus,
                    onPressed: () async {
                      bool isValid = _formKey.currentState?.validate() ?? false;

                      if (isValid) {
                        if (isEdit) {
                          await _updateTaskApi(editIndex, {
                            'name': _taskNameEditingController.text.trim(),
                            'description':
                                _taskDescriptionEditingController.text.trim()
                          }).whenComplete(() {
                            _showStatus(
                                'Task', 'Task updated.', BootstrapIcons.pencil);
                            Navigator.pop(context);
                          });
                        } else {
                          await _storeTaskApi({
                            'name': _taskNameEditingController.text.trim(),
                            'description':
                                _taskDescriptionEditingController.text.trim()
                          }).whenComplete(() {
                            Navigator.pop(context);
                            _showStatus('Task', "Task successfully created.",
                                BootstrapIcons.check);
                          }).onError((error, stackTrace) {
                            _showStatus("Task", "Task creation failed.",
                                BootstrapIcons.stop);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStatus(String title, String subtitle, IconData icon) {
    return StatusAlert.show(
      context,
      duration: const Duration(seconds: 1),
      title: title,
      subtitle: subtitle,
      configuration: IconConfiguration(icon: icon),
      maxWidth: 350,
    );
  }
}
