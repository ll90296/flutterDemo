import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? ElevatedButton.styleFrom();
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? OutlinedButton.styleFrom();
    
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? TextButton.styleFrom();
    
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}