import 'package:flutter/material.dart';
import 'package:topgo_web/styles.dart';

class RadioChoose extends StatefulWidget {
  final List<String> text;
  const RadioChoose({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _RadioChooseState createState() => _RadioChooseState();
}

class _RadioChooseState extends State<RadioChoose> {
  String? choose;

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                  },
                ),
                Text(v, style: TxtStyle.H5),
              ],
            ),
          )
          .toList(),
    );
  }
}
