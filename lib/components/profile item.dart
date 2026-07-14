import 'package:flutter/material.dart';

class ProfileDataItems extends StatelessWidget {
  const ProfileDataItems({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });
  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.right),
      subtitle: Text(subtitle, textAlign: TextAlign.right),
      leading: icon != null
          ? Icon(icon, color: const Color.fromARGB(255, 59, 148, 220))
          : null,
    );
  }
}
