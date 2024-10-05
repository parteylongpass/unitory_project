import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? bgColor;

  const CustomButton(
      {super.key, required this.text, required this.textColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
