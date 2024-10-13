import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/colors.dart';


class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final int? maxLines;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    this.controller,
    this.validator,
    this.maxLines,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BD_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines?? 1,
      controller: controller,
      validator: validator,
      cursorColor: PRIMARY_COLOR,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(
          20.0,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0, // 16.0이 기본값
        ),
        errorText: errorText,
        filled: true,
        fillColor: INPUT_BG_COLOR,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: BorderSide(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
    );
  }
}
