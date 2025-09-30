import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.forceErrorText,
    this.decoration,
    this.keyboardType,
    this.style = const TextStyle(color: Color(0xff8C8C8C)),
    this.textDirection,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.clipBehavior = Clip.hardEdge,
    this.fillColor = const Color(0xff181818),
    this.borderRadius = 12.0,
    this.validator,
    this.hintStyle = const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 16,
      color: Color(0xff8C8C8C),
    ),
    this.hintText,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),
    this.borderColor = const Color(0xff3A3A3A),
    this.focusedBorderColor = const Color(0xff3A3A3A),
    this.errorBorderColor = Colors.red,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? forceErrorText;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextDirection? textDirection;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final Clip clipBehavior;
  final Color fillColor;
  final double borderRadius;
  final FormFieldValidator<String>? validator;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  InputDecoration _defaultInputDecoration() {
    return InputDecoration(
      suffixIcon: widget.suffixIcon != null
          ? IconButton(
              icon: Icon(
                _obscureText ? widget.suffixIcon : Icons.visibility_off,
                color: const Color(0xff8C8C8C), // Match hint color
              ),
              onPressed: _toggleVisibility,
            )
          : null,
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
      enabled: widget.enabled,
      hintText: widget.hintText,
      hintStyle:
          widget.hintStyle ??
          GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 16.sp,
            color: const Color(0xff8C8C8C),
          ),
      contentPadding: widget.contentPadding,
      fillColor: widget.fillColor,
      filled: true,
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(focused: true),
      errorBorder: _inputBorder(error: true),
    );
  }

  OutlineInputBorder _inputBorder({bool focused = false, bool error = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: error
            ? widget.errorBorderColor
            : (focused ? widget.focusedBorderColor : widget.borderColor),
        width: 1.0, // Keep original width
      ),
      borderRadius: BorderRadius.circular(widget.borderRadius.r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        initialValue: widget.initialValue,
        focusNode: widget.focusNode,
        decoration: widget.decoration ?? _defaultInputDecoration(),
        keyboardType: widget.keyboardType,
        style: widget.style,
        textDirection: widget.textDirection,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        clipBehavior: widget.clipBehavior,
        obscureText: _obscureText,
      ),
    );
  }
}
