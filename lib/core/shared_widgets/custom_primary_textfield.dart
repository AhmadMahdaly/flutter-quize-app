import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CustomPrimaryTextfield extends StatelessWidget {
  const CustomPrimaryTextfield({
    this.controller,
    this.focusNode,
    super.key,
    this.isPassword,
    this.suffix,
    this.validator,
    this.textInputAction,
    this.autofillHints,
    this.prefix,
    this.textAlign,
    this.text,
    this.style,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.maxLines = 1,
    this.onFieldSubmitted,
  });
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isPassword;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextAlign? textAlign;
  final String? text;
  final TextStyle? style;
  final bool? readOnly;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final int? maxLines;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      style:
          style ??
          AppTextStyle.style14W500.copyWith(color: theme.colorScheme.onSurface),
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      cursorColor: theme.colorScheme.primary,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        hint: Text(
          text ?? '',
          style:
              style ??
              AppTextStyle.style14W600.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
        ),
        border: customOutlineInputBorder(),
        focusedBorder: customOutlineInputBorder(),
        enabledBorder: customOutlineInputBorder(),
        disabledBorder: customOutlineInputBorder(),
        suffixIcon: suffix,
        prefixIcon: prefix,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),

      textInputAction: textInputAction,
      autofillHints: autofillHints,
    );
  }
}

OutlineInputBorder customOutlineInputBorder() {
  return OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(
      width: 0.50,
      strokeAlign: BorderSide.strokeAlignOutside,
      color: AppColors.iconColorGray,
    ),
  );
}
