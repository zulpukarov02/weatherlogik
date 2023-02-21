import 'package:flutter/material.dart';
import 'package:weatherlogik/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  final IconData icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 60,
      color: AppColors.white,
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
    );
  }
}
