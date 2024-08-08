import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';

class MaterialButtons extends StatefulWidget {
  final Color? textcolor;
  final Color? meterialColor;
  final double? containerheight;
  final double? containerwidth;
  final double elevationsize;
  final void Function()? onTap;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onPressed;
  final String text;
  final double? fontSize;
  final FontWeight? textweight;

  const MaterialButtons({
    super.key,
    this.meterialColor,
    this.onTap,
    this.containerheight,
    required this.elevationsize,
    this.borderRadius,
    required this.text,
    this.fontSize,
    this.textcolor,
    this.containerwidth,
    this.textweight,
    this.onPressed,
  });

  @override
  State<MaterialButtons> createState() => _MaterialButtonsState();
}

class _MaterialButtonsState extends State<MaterialButtons> {
  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 200),
      bound: 0.1,
      onTap: widget.onTap,
      child: Material(
        color: widget.meterialColor,
        elevation: widget.elevationsize,
        borderRadius: widget.borderRadius,
        child: SizedBox(
          height: widget.containerheight,
          width: widget.containerwidth,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.textweight,
                color: widget.textcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
