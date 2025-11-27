// custom_text_filed.dart

import 'package:flutter/material.dart';

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
    this.onTap,                    // নতুন: ট্যাপ করার জন্য
    this.readOnly = false,         // নতুন: রিড-ওনলি মোড
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
    this.suffixIcon,               // IconData? (যেমন Icons.keyboard_arrow_down)
    this.prefixIcon,
    this.obscureText = false,
    this.pprefixIconColor,
    this.items,                    // Dropdown এর জন্য (যদি চাও পরে ব্যবহার করতে পারো)
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
  final VoidCallback? onTap;            // নতুন
  final bool readOnly;                  // নতুন
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
  final Color? pprefixIconColor;
  final List<DropdownMenuItem<String>>? items;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _selectedValue = widget.initialValue;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  InputDecoration _defaultInputDecoration() {
    return InputDecoration(
      suffixIcon: widget.suffixIcon != null
          ? (widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? widget.suffixIcon : Icons.visibility_off,
                    color: const Color(0xff8C8C8C),
                  ),
                  onPressed: _toggleVisibility,
                )
              : Icon(
                  widget.suffixIcon,
                  color: const Color(0xff8C8C8C),
                ))
          : null,
      prefixIconColor: widget.pprefixIconColor ?? const Color.fromARGB(255, 255, 255, 255),
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
      enabled: widget.enabled,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Color(0xff8C8C8C),
          ),
      contentPadding: widget.contentPadding,
      fillColor: widget.fillColor,
      filled: true,
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(focused: true),
      errorBorder: _inputBorder(error: true),
      disabledBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder({bool focused = false, bool error = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: error
            ? widget.errorBorderColor
            : (focused ? widget.focusedBorderColor : widget.borderColor),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: widget.items != null
          ? DropdownButtonFormField<String>(
              value: _selectedValue,
              hint: Text(widget.hintText ?? '', style: widget.hintStyle),
              items: widget.items,
              onChanged: widget.enabled
                  ? (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                      widget.onChanged?.call(value ?? '');
                    }
                  : null,
              decoration: widget.decoration ?? _defaultInputDecoration(),
              style: widget.style,
              dropdownColor: widget.fillColor,
              iconEnabledColor: const Color(0xff8C8C8C),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            )
          : TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              readOnly: widget.readOnly,        // এখানে ফরওয়ার্ড করা হলো
              onTap: widget.onTap,              // এখানে ফরওয়ার্ড করা হলো
              enabled: widget.enabled,
            ),
    );
  }
}