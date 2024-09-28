import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String? hintText;
  final int? maxlength;
  final String? labeltext;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomTextfield({
    Key? key,
    this.hintText,
    this.maxlength,
    this.labeltext,
    this.textInputAction,
    this.controller,
    this.validator,
    this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxlength,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorText: errorText,
        hintText: hintText,
        labelText: labeltext,
        hintStyle: const TextStyle(color: Colors.grey),
        border: _returnBorder(),
        errorBorder: _returnBorder(Colors.red),
        focusedBorder: _returnBorder(),
        enabledBorder: _returnBorder(),
      ),
    );
  }
}

OutlineInputBorder _returnBorder([Color? color]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color ?? Colors.grey),
  );
}
