import 'package:flutter/material.dart';

class CustomDrawerItem extends StatelessWidget {
  const CustomDrawerItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
    this.iconSize = 30,
    this.textSize = 26
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final double iconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      leading: Icon(icon, size: iconSize,),
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline3?.copyWith(fontSize: textSize),
      ),
    );
  }
}