import 'package:flutter/material.dart';
import 'package:tasker/constants/app.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.appBar,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleSpacing: 0,
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: AppConstants.backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
