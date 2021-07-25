import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

enum ButtonType {
  Accept,
  Decline,
  Select,
  Panel,
}

class Button extends StatefulWidget {
  final String text;
  final ButtonType buttonType;
  final Future<void> Function() onPressed;
  final bool filled;

  const Button({
    Key? key,
    required this.text,
    required this.buttonType,
    required this.onPressed,
    this.filled = true,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      reverseDuration: Duration(milliseconds: 0),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _tapDown(TapDownDetails details) => _controller.forward();

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    LinearGradient gradient = widget.buttonType == ButtonType.Accept
        ? GrdStyle.accept
        : widget.buttonType == ButtonType.Decline
            ? GrdStyle.decline
            : widget.buttonType == ButtonType.Panel
                ? GrdStyle.panel
                : GrdStyle.select;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 44,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: gradient,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color:
                  widget.filled ? Colors.transparent : ClrStyle.lightBackground,
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => widget.filled
                    ? LinearGradient(colors: [
                        ClrStyle.lightBackground,
                        ClrStyle.lightBackground
                      ]).createShader(bounds)
                    : gradient.createShader(bounds),
                child: Text(
                  widget.text,
                  style: TxtStyle.H4.copyWith(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
