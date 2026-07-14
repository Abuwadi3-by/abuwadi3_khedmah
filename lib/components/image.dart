import 'package:flutter/material.dart';

// ignore: camel_case_types
class Insert_Image extends StatelessWidget {
  const Insert_Image({
    super.key,
    required this.image,
    required this.height,
    required this.width,
    this.color,
  });
  final String image;
  final double height, width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(100),
      ),

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(100),
        child: Image.asset(image, fit: BoxFit.contain),
      ),
    );
  }
}
