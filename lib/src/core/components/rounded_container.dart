import 'package:flutter/material.dart';

class RoundedContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? child;
  final bool hasBorder;
  final EdgeInsetsGeometry? padding;
  const RoundedContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.child,
    this.hasBorder = true,
    this.padding,
  }) : assert(
         borderWidth == null || borderWidth >= 0,
         'Border width must be non-negative or null',
       );

  @override
  State<RoundedContainer> createState() => _RoundedContainerState();
}

class _RoundedContainerState extends State<RoundedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 24.0),
        border: widget.hasBorder
            ? BoxBorder.all(
                color:
                    widget.borderColor ??
                    Theme.of(context).colorScheme.tertiary,
                width: widget.borderWidth ?? 4.0,
              )
            : null,
      ),
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: widget.child,
      ),
    );
  }
}
