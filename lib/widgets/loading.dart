import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:topgo_web/styles.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (bounds) => GrdStyle.panel.createShader(bounds),
        child: LoadingBouncingGrid.square(
          size: 128,
          itemBuilder: (context, int) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
