import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class BorderBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final bool selected;
  final double borderWidth;
  final LinearGradient? gradient;

  const BorderBox({
    Key? key,
    required this.child,
    this.height,
    this.width = double.infinity,
    this.selected = false,
    this.borderWidth = 1.5,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width + borderWidth * 2,
          height: height != null ? height! + borderWidth * 2 : null,
          decoration: BoxDecoration(
            gradient: gradient != null ? gradient : GrdStyle.lightPanel,
            borderRadius: BorderRadius.circular(6),
            boxShadow: borderWidth > 0
                ? [BoxShadow(color: ClrStyle.dropShadow, blurRadius: 3)]
                : [],
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
