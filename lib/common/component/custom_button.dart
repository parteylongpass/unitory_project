import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? bgColor;
  final GestureTapCallback? onCustomButtonPressed;
  final double? textSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    this.bgColor,
    this.onCustomButtonPressed,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCustomButtonPressed,
      child: Container(
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
              fontSize: textSize?? 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
