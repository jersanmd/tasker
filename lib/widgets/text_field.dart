import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tasker/constants/app.dart';

class TextFieldWidget extends StatelessWidget {
  final String name;
  final String labelText;
  final TextEditingController? controller;
  final bool isObscure;
  final TextInputType textInputType;
  final List<TextInputFormatter>? textInputFormatters;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final TextInputAction? textInputAction;

  const TextFieldWidget({
    super.key,
    required this.name,
    required this.labelText,
    this.controller,
    required this.isObscure,
    required this.textInputType,
    this.textInputFormatters,
    required this.autovalidateMode,
    this.validator,
    this.maxLines,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,
      obscureText: isObscure,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      autovalidateMode: autovalidateMode,
      validator: validator,
      maxLines: isObscure ? 1 : maxLines,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: AppConstants.primaryTextColor),
          filled: true,
          fillColor: AppConstants.textFieldColor,
          contentPadding: const EdgeInsets.all(AppConstants.textFieldPadding),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius:
                  BorderRadius.circular(AppConstants.textFieldBorderRadius))),
    );
  }
}
