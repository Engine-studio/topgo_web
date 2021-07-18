import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class Error extends StatelessWidget {
  final String text;
  const Error({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Screen is too small', style: TxtStyle.H1),
    );
  }
}
