import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/icons/x.png', width: 25),
          Opacity(
            opacity: 0.1,
            child: Container(color: ClrStyle.icons),
          ),
        ],
      ),
    );
  }
}
