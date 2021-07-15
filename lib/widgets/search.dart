import 'package:flutter/widgets.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/input.dart';

class SearchLine extends StatelessWidget {
  const SearchLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget spacer = SizedBox(width: main.fullSize ? 24 : 16);
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Flexible(child: Input(text: 'Введите запрос')),
          spacer,
          Container(width: 190, color: Color(0xFF00FFF0)),
          spacer,
          SizedBox(
            width: 150,
            child: Button(
              text: 'Поиск',
              buttonType: ButtonType.Panel,
              //TODO: impl func
              onPressed: () async => {},
            ),
          ),
        ],
      ),
    );
  }
}
