import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';

class RadioChoose extends StatefulWidget {
  final List<String> text;
  final void Function(String?) change;
  final bool error;

  const RadioChoose({
    Key? key,
    required this.text,
    required this.change,
    this.error = false,
  }) : super(key: key);

  @override
  _RadioChooseState createState() => _RadioChooseState();
}

class _RadioChooseState extends State<RadioChoose> {
  String? choose;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          unselectedWidgetColor:
              widget.error ? Colors.red.withOpacity(0.35) : null),
      child: Wrap(
        spacing: 30,
        children: widget.text
            .map(
              (v) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    activeColor: ClrStyle.lightPanel,
                    splashRadius: 0,
                    value: v,
                    groupValue: choose,
                    onChanged: (String? value) {
                      setState(() {
                        choose = value;
                      });
                      widget.change(value);
                    },
                  ),
                  Text(v, style: TxtStyle.H5),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
