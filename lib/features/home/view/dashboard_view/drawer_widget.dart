import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({required this.icon, required this.text, required this.onTap, super.key});
  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        // selected: _innerRouterKey.currentContext!.routeData.name == 'HomeRoute',
      ),
    );
  }
}
