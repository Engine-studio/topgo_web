import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/input.dart';
import 'package:provider/provider.dart';

enum SearchType {
  All,
  Finding,
  Cooking,
  Delivering,
  Done,
}

String toString(SearchType type) => type == SearchType.Finding
    ? 'В поиске'
    : type == SearchType.Cooking
        ? 'Готовятся'
        : type == SearchType.Delivering
            ? 'Доставляются'
            : type == SearchType.Done
                ? 'Завершенные'
                : 'Все';

class SearchLine extends StatefulWidget {
  final bool history;
  const SearchLine({Key? key, this.history = false}) : super(key: key);

  @override
  _SearchLineState createState() => _SearchLineState();
}

class _SearchLineState extends State<SearchLine> {
  late TextEditingController _controller;
  SearchType type = SearchType.All;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Restaurant self = context.read<Restaurant>();
    Widget spacer = SizedBox(width: main.fullSize ? 24 : 16);
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Flexible(
            child: BorderBox(
              borderRadius: 4,
              child: Input(
                text: 'Введите запрос',
                styling: false,
                controller: _controller,
                onSubmit: () => !widget.history
                    ? context.read<Restaurant>().formShown(
                          text: _controller.text,
                          type: type,
                        )
                    : self.formShownHistory(text: _controller.text),
              ),
            ),
          ),
          if (!widget.history) spacer,
          if (!widget.history)
            BorderBox(
              borderRadius: 4,
              width: 190,
              child: DropdownButton<SearchType>(
                isDense: true,
                iconSize: 29,
                isExpanded: true,
                elevation: 0,
                value: type,
                items: <SearchType>[
                  SearchType.All,
                  SearchType.Finding,
                  SearchType.Cooking,
                  SearchType.Delivering,
                  SearchType.Done,
                ].map((SearchType value) {
                  return DropdownMenuItem<SearchType>(
                    value: value,
                    child: Center(
                      child: Text(
                        toString(value),
                        style: TxtStyle.Text,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (pushedValue) => {
                  setState(() {
                    type = pushedValue!;
                  })
                },
              ),
            ),
          spacer,
          SizedBox(
            width: 150,
            child: Button(
              text: 'Поиск',
              buttonType: ButtonType.Panel,
              onPressed: () async => !widget.history
                  ? context
                      .read<Restaurant>()
                      .formShown(text: _controller.text, type: type)
                  : self.formShownHistory(text: _controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
