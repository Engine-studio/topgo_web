import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';

class CloseButton extends StatelessWidget {
  final bool white;

  const CloseButton({Key? key, this.white = false}) : super(key: key);

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
          Opacity(
            opacity: white ? 0.8 : 0.1,
            child: Container(color: white ? Color(0xFFFFFFFF) : ClrStyle.icons),
          ),
          Image.asset('assets/icons/x.png', width: 15),
        ],
      ),
    );
  }
}
