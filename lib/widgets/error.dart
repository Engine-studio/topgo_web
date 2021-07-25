import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class Error extends StatelessWidget {
  final Map<String, dynamic> text;
  const Error({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error on api query\n$text',
        style: TxtStyle.H1.copyWith(
          color: Color(0xFFFF0000),
        ),
      ),
    );
  }
}
