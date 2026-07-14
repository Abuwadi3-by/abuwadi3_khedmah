import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.align,
  });
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      textScaler: TextScaler.linear(0.7),
      style: TextStyle(color: color, fontSize: size ?? 20, fontWeight: weight),
    );
  }
}
