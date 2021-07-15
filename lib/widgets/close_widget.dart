import 'package:flutter/material.dart';

class CloseWidget extends StatelessWidget {

  const CloseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: Stack(children: [
        Center(child: Image.asset("assets/icons/close.png"),),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.0)),
        )
      ],),
    );
  }
}
