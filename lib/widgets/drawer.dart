import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:tasker/screens/auth/login.dart';
import 'package:tasker/screens/tasks/index.dart';
import 'package:tasker/screens/users/index.dart';
import 'package:tasker/widgets/drawer_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerTileWidget(
            icon: BootstrapIcons.list_task,
            title: "Tasks",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskIndexScreen(),
                ),
              );
            },
          ),
          DrawerTileWidget(
            icon: BootstrapIcons.people,
            title: "Users",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserIndexScreen(),
                ),
              );
            },
          ),
          DrawerTileWidget(
            icon: BootstrapIcons.power,
            title: "Logout",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
