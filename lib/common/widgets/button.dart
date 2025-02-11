import 'package:flutter/material.dart';
import 'package:postapp/common/theme/colors.dart';
import 'package:postapp/common/theme/fonts.dart';

enum ButtonType { primary, secondary, primaryColor, disabled }

class Button extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final double height;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;
  final Color borderColor;
  final Color color;
  final ButtonType type;
  final Icon? leftIcon;
  final Icon? rightIcon;
  final bool showBorder;
  final Color backgroundColor;

  const Button({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.type = ButtonType.primary,
    this.leftIcon,
    this.rightIcon,
    this.height = 43,
    this.width = double.infinity,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.iconSize = 21,
    this.borderColor = PostColors.lightWhite,
    this.color = PostColors.white,
    this.backgroundColor = PostColors.primaryColor,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            overlayColor: color.withOpacity(0.3),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
          ),
          child: Container(
            width: double.infinity,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: type == ButtonType.disabled ? PostColors.lightGrey : backgroundColor,
              shape: RoundedRectangleBorder(
                side: showBorder
                    ? BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: borderColor,
                )
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leftIcon != null)
                  SizedBox(
                    width: iconSize + 3,
                    height: iconSize + 3,
                    child: Icon(
                      leftIcon?.icon,
                      color: color,
                      size: iconSize,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                      buttonText,
                      style: PostFonts.highlightEmphasis.copyWith(
                          color: type == ButtonType.disabled
                              ? PostColors.white
                              : color
                      )
                  ),
                ),
                if (rightIcon != null)
                  SizedBox(
                    width: iconSize + 3,
                    height: iconSize + 3,
                    child: Icon(
                      rightIcon?.icon,
                      color: color,
                      size: iconSize,
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}