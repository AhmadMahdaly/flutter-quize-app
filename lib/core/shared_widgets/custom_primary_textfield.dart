import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      style: style ?? interRegular.copyWith(fontSize: 14.sp),

      textAlign: textAlign ?? TextAlign.center,
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      cursorColor: AppColors.forthColor,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        hint: Text(
          text ?? '',
          style: style ?? interMedium.copyWith(fontSize: 18.sp),
        ),
        border: customOutlineInputBorder(),
        focusedBorder: customOutlineInputBorder(),
        enabledBorder: customOutlineInputBorder(),
        disabledBorder: customOutlineInputBorder(),
        suffixIcon: suffix,
        prefixIcon: prefix,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: AppColors.offwhiteColor,
      ),

      textInputAction: textInputAction,
      autofillHints: autofillHints,
    );
  }

  OutlineInputBorder customOutlineInputBorder() {
    return OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(
        width: 0.50,
        strokeAlign: BorderSide.strokeAlignOutside,
        color: AppColors.iconColorGray,
      ),
    );
  }
}
