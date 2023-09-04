import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tasker/constants/app.dart';
import 'package:tasker/widgets/elevated_button.dart';
import 'package:tasker/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
            child: Scrollbar(
          child: SingleChildScrollView(
              child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.textFieldPadding),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'TAS\nKER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1,
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.taskerTitleTextSize,
                      ),
                    ),
                    const SizedBox(height: AppConstants.textFieldPadding * 2),
                    TextFieldWidget(
                      name: 'username',
                      labelText: 'Username',
                      isObscure: false,
                      textInputType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: AppConstants.textFieldPadding),
                    TextFieldWidget(
                      name: 'password',
                      labelText: 'Password',
                      isObscure: true,
                      textInputType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: AppConstants.textFieldPadding),
                    ElevatedButtonWidget(
                      label: 'Login',
                      buttonColor: AppConstants.primaryColor,
                      buttonTextColor: AppConstants.backgroundColor,
                      icon: BootstrapIcons.box_arrow_down_right,
                      onPressed: () {
                        bool isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (isValid) {
                          print("Successfully logged in!");
                        } else {}
                      },
                    ),
                    const SizedBox(height: AppConstants.textFieldPadding * 2),
                    SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () {
                        // _showButtonPressDialog(context, 'Google (dark)');
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            AppConstants.textFieldBorderRadius,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.textFieldPadding / 2),
                    SignInButton(
                      Buttons.GitHub,
                      text: "Sign up with GitHub",
                      onPressed: () {
                        // _showButtonPressDialog(context, 'Github');
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 22),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            AppConstants.textFieldBorderRadius,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
        )),
      ),
    );
  }
}
