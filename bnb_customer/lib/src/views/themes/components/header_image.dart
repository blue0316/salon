import 'package:flutter/material.dart';

class ThemeHeaderImage extends StatelessWidget {
  final String image;
  const ThemeHeaderImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }
}
