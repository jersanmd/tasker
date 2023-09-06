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

  List<Map<String, dynamic>> _tasks = [];
  final Box<dynamic> _taskerBox = Hive.box("tasker_database");

  void _refreshTasks() {
    final task = _taskerBox.keys.map((key) {
      final task = _taskerBox.get(key);

      return {
        'key': key,
        'name': task['name'],
        'description': task['description']
      };
    }).toList();

    setState(() {
      _tasks = task.reversed.toList();
    });
  }

  Future<void> _storeTask(Map<String, dynamic> task) async {
    await _taskerBox.add(task);
    _refreshTasks();

    _taskNameEditingController.text = "";
    _taskDescriptionEditingController.text = "";
  }

  Future<void> _updateTask(int key, Map<String, dynamic> task) async {
    await _taskerBox.put(key, task);
    _refreshTasks();

    _taskNameEditingController.text = "";
    _taskDescriptionEditingController.text = "";
  }

  Future<void> _deleteTask(int key) async {
    await _taskerBox.delete(key);
    _refreshTasks();
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks();
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
          _createTask(context);
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
                                _createTask(context);
                              });
                            },
                          ),
                          SlidableAction(
                            icon: BootstrapIcons.trash_fill,
                            foregroundColor: AppConstants.primaryColor,
                            onPressed: (context) {
                              _deleteTask(_tasks[index]['key']);
                              StatusAlert.show(
                                context,
                                duration: const Duration(seconds: 1),
                                title: 'Task',
                                subtitle: 'Task deleted.',
                                configuration: const IconConfiguration(
                                    icon: BootstrapIcons.trash_fill),
                                maxWidth: 260,
                              );
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

  void _createTask(BuildContext context) {
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
                      icon:
                          isEdit ? BootstrapIcons.pencil : BootstrapIcons.plus,
                      onPressed: () {
                        bool isValid =
                            _formKey.currentState?.validate() ?? false;

                        if (isValid) {
                          setState(() {
                            if (isEdit) {
                              _updateTask(_tasks[editIndex]['key'], {
                                'name': _taskNameEditingController.text.trim(),
                                'description': _taskDescriptionEditingController
                                    .text
                                    .trim()
                              });
                              StatusAlert.show(
                                context,
                                duration: const Duration(seconds: 1),
                                title: 'Task',
                                subtitle: 'Task updated.',
                                configuration: const IconConfiguration(
                                    icon: BootstrapIcons.pencil),
                                maxWidth: 260,
                              );
                            } else {
                              _storeTask({
                                'name': _taskNameEditingController.text.trim(),
                                'description': _taskDescriptionEditingController
                                    .text
                                    .trim()
                              });
                              StatusAlert.show(
                                context,
                                duration: const Duration(seconds: 1),
                                title: 'Task',
                                subtitle: 'New task created.',
                                configuration: const IconConfiguration(
                                    icon: BootstrapIcons.check),
                                maxWidth: 260,
                              );
                            }
                          });

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
