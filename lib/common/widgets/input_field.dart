import 'package:flutter/material.dart';
import 'package:postapp/common/theme/colors.dart';
import 'package:postapp/common/theme/fonts.dart';

enum InputType { floatingTitle, separateTitle, noTitle, disabled}

class InputField extends StatefulWidget {
  final InputType type;
  final Icon? leadingIcon;
  final Color color;
  final double height;
  final Color fillColor;
  final String labelText;
  final String? placeholderText;
  final String? helpText;
  final bool obscureText;
  final bool isTextArea;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool numberInput;

  const InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.type = InputType.separateTitle,
    this.leadingIcon,
    this.color = PostColors.grey,
    this.height = 44,
    this.fillColor = PostColors.lighterWhite,
    this.obscureText = false,
    this.numberInput = false,
    this.isTextArea = false,
    this.helpText,
    this.onChanged,
    this.placeholderText,
  });

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {

  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText ? true : false;
  }

  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.type == InputType.separateTitle || widget.type == InputType.disabled)
          Text(
            widget.labelText,
            style: PostFonts.contentRegular,
          ),
        if(widget.type == InputType.separateTitle || widget.type == InputType.disabled)
          const SizedBox(
            height: 6,
          ),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: PostColors.lighterWhite,
          ),
          child: TextField(
            maxLines: widget.isTextArea ? 10 : 1,
            onChanged: widget.onChanged != null ? (value) => widget.onChanged!(value) : null,
            controller: widget.type == InputType.disabled ? null : widget.controller,
            obscureText: obscureText,
            keyboardType: widget.numberInput ? TextInputType.number : widget.isTextArea ? TextInputType.multiline : TextInputType.text,
            enabled: widget.type == InputType.disabled ? false : true,
            style: PostFonts.highlightRegular,
            decoration: InputDecoration(
              hintText: widget.placeholderText ?? widget.labelText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              prefixIcon: widget.leadingIcon != null
                  ? Text(
                '\nRs.',
                style: PostFonts.highlightRegular.copyWith(
                    color: PostColors.neutral300,
                    height: 1
                ),
                textAlign: TextAlign.center,
              )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: PostColors.neutral300,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ) : null,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: PostColors.neutral300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: PostColors.primaryColor)),
              hintStyle: TextStyle(color: PostColors.neutral300),
            ),
          ),
        ),
        if(widget.helpText != null)
          Column(
            children: [
              const SizedBox(height: 3,),
              Text(
                widget.helpText!,
                style: PostFonts.captionRegular.copyWith(
                    color: PostColors.errorColor
                ),
              )
            ],
          ),
      ],
    );
  }
}