import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:tasker/widgets/drawer_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerTileWidget(
            icon: BootstrapIcons.list_task,
            title: "Tasks",
          ),
          DrawerTileWidget(
            icon: BootstrapIcons.people,
            title: "Users",
          )
        ],
      ),
    );
  }
}
