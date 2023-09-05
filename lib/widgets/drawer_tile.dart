import 'package:flutter/material.dart';
import 'package:tasker/constants/app.dart';

class DrawerTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const DrawerTileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: AppConstants.primaryTextColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppConstants.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      splashColor: AppConstants.splashColor,
    );
  }
}
