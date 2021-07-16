import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class BorderBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height, borderRadius;
  final bool selected;
  final double borderWidth;
  final LinearGradient? gradient;
  final MainAxisSize? size;

  const BorderBox({
    Key? key,
    required this.child,
    this.height,
    this.width = double.infinity,
    this.borderRadius,
    this.selected = false,
    this.borderWidth = 1.5,
    this.gradient,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: size ?? MainAxisSize.min,
      children: [
        Container(
          width: width + borderWidth * 2,
          height: height != null ? height! + borderWidth * 2 : null,
          decoration: BoxDecoration(
            gradient: gradient != null ? gradient : GrdStyle.lightPanel,
            borderRadius: BorderRadius.circular(borderRadius ?? 9),
            boxShadow: borderWidth > 0
                ? [BoxShadow(color: ClrStyle.dropShadow, blurRadius: 3)]
                : [],
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(borderRadius ?? 9),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
