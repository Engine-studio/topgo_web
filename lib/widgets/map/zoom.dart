import 'package:flutter/widgets.dart';

class Zoom extends StatelessWidget {
  final bool out;
  const Zoom({Key? key, this.out = true}) : super(key: key);

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
            opacity: 0.8,
            child: Container(color: Color(0xFFFFFFFF)),
          ),
          Image.asset(
            out ? 'assets/icons/minus.png' : 'assets/icons/plus.png',
            width: 20,
          ),
        ],
      ),
    );
  }
}
