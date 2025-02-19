import 'package:flutter/material.dart';

import '../../core/ui.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputAction? buttonAction;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final String? initialVa;
  final Function(String?)? onSubmit;
  final bool readonly;
  final Widget? preFix;
  final bool obscure;
  final TextInputType? keyboardType;
  final int? maxLines;
  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.controller,
    this.onSubmit,
    this.onChanged,
    this.readonly = false,
    this.preFix,
    this.keyboardType,
    this.maxLines,
    this.initialVa,
    this.obscure = false,
    this.validator,
    this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly,
      obscureText: obscure,
      initialValue: initialVa,
      validator: validator,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      textInputAction: buttonAction,
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.text),
      onSaved: onSubmit,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: AppColors.text),
        hintStyle: const TextStyle(color: AppColors.text),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        suffixIcon: preFix,
        labelText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.text,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.text,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}
