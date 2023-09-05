import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
        onPressed: () {
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
                              _deleteTask(index);
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

  void _deleteTask(index) {
    setState(() {
      _tasks.removeAt(index);
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: 'Task',
        subtitle: 'Task deleted.',
        configuration: const IconConfiguration(icon: BootstrapIcons.trash_fill),
        maxWidth: 260,
      );
    });
  }

  void _editTask(index, name, description) {
    setState(() {
      _tasks[index] = {'name': name, 'description': description};
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: 'Task',
        subtitle: 'Task updated.',
        configuration:
            const IconConfiguration(icon: BootstrapIcons.pencil_fill),
        maxWidth: 260,
      );
    });

    isEdit = false;
    _taskNameEditingController.text = "";
    _taskDescriptionEditingController.text = "";
  }

  void _createTask(BuildContext context) {
    // _taskNameEditingController.clear();
    // _taskDescriptionEditingController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create task'),
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
                      label: "Create",
                      buttonColor: AppConstants.primaryColor,
                      buttonTextColor: AppConstants.backgroundColor,
                      icon: BootstrapIcons.plus,
                      onPressed: () {
                        bool isValid =
                            _formKey.currentState?.validate() ?? false;

                        if (isValid) {
                          setState(() {
                            if (isEdit) {
                              _editTask(
                                  editIndex,
                                  _taskNameEditingController.text,
                                  _taskDescriptionEditingController.text);
                            } else {
                              _tasks.add({
                                'name': _taskNameEditingController.text.trim(),
                                'description': _taskDescriptionEditingController
                                    .text
                                    .trim()
                              });
                            }
                          });

                          Navigator.pop(context);

                          StatusAlert.show(
                            context,
                            duration: Duration(seconds: 2),
                            title: 'Task',
                            subtitle: 'Task created.',
                            configuration: IconConfiguration(icon: Icons.done),
                            maxWidth: 260,
                          );

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Successfully created new task.'),
                          //   ),
                          // );
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
