import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;
  final Widget child;

  const CustomButton({super.key,  this.width =0,  this.height = 0,  this.color = Colors.white, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration:BoxDecoration(
          color: Colors.white,
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
