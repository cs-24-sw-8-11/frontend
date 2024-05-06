import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{
  final Icon icon;
  final String tooltipstring;
  final void Function() onPressed;

  const CustomIconButton({super.key, required this.icon, required this.tooltipstring, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltipstring,
      color: Colors.white,
    );
  }
}