import 'package:flutter/material.dart';
import 'package:graduation_project/components/text%20form.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    this.contain,
    this.leading,
    this.trailing,
    this.height,
    this.color,
    this.onTap,
  });
  final String title;
  final String? contain;
  final Widget? leading;
  final Widget? trailing;
  final double? height;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.grey[50],
      elevation: 2.0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        minVerticalPadding: height,
        onTap: onTap,
        title: TextForm(
          text: title,
          align: TextAlign.right,
          weight: FontWeight.bold,
        ),
        subtitle: contain != null
            ? TextForm(text: contain!, align: TextAlign.right, size: 16)
            : null,
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
