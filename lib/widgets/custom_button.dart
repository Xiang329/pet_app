import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class CustomButton extends StatefulWidget {
  final Future<void> Function()? asyncOnPressed;
  final void Function()? syncOnPressed;
  final String buttonText;
  final bool errorStyle;

  const CustomButton({
    super.key,
    this.asyncOnPressed,
    this.syncOnPressed,
    required this.buttonText,
    this.errorStyle = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (widget.asyncOnPressed != null) {
      setState(() {
        _isLoading = true;
      });
      await widget.asyncOnPressed!();
      setState(() {
        _isLoading = false;
      });
    } else if (widget.syncOnPressed != null) {
      widget.syncOnPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isLoading ||
              (widget.asyncOnPressed == null && widget.asyncOnPressed == null)
          ? null
          : _onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: (widget.errorStyle == true)
            ? UiColor.errorColor
            : UiColor.theme2Color,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              widget.buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
    );
  }
}
