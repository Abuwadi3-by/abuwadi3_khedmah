import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final BorderRadiusGeometry borderradius;
  final EdgeInsets? padding;
  final Color? color;
  final double? height;
  const ButtonForm({
    super.key,
    required this.onPressed,
    required this.title,
    required this.borderradius,
    this.padding,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: padding,
      color: color ?? Color.fromARGB(255, 59, 115, 160),
      height: height ?? 60,
      shape: RoundedRectangleBorder(borderRadius: borderradius),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
