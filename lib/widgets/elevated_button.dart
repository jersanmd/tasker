import 'package:flutter/material.dart';
import 'package:tasker/constants/app.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String label;
  final Color buttonColor;
  final Color buttonTextColor;
  final IconData icon;
  final VoidCallback? onPressed;

  const ElevatedButtonWidget({
    super.key,
    required this.label,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: AppConstants.backgroundColor,
      ),
      label: Text(label,
          style: TextStyle(
            color: buttonTextColor,
            fontSize: AppConstants.buttonTextSize,
          )),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.all(
          AppConstants.textFieldPadding,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              AppConstants.textFieldBorderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
