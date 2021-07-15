import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/close_button.dart' as topgo;

class DialogBox extends StatelessWidget {
  final Widget child;
  final double? height, width;
  final EdgeInsets? padding;
  final bool closeButton;

  const DialogBox({
    Key? key,
    this.width,
    this.height,
    this.padding,
    required this.child,
    this.closeButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ClrStyle.lightBackground,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Stack(
          children: [
            child,
            if (closeButton)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    child: topgo.CloseButton(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
