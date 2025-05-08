import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.color,
    required this.onPressed,
    required this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(

          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(-4, 4),
              blurRadius: 10,
              color: Colors.grey.shade400,
              spreadRadius: .5,
            ),
            BoxShadow(
              offset: Offset(4, -4),
              blurRadius: 10,
              color: Colors.grey.shade400,
              spreadRadius: .5,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

}
