import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: Stack(children: [
        Center(child: Image.asset("assets/icons/x.png"),),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.0)),
        )
      ],),
    );
  }
}
