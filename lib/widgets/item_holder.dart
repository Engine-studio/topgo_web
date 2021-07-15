import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class ItemHolder extends StatelessWidget {
  final double? width;
  final String header;
  final Widget item;
  const ItemHolder({
    Key? key,
    required this.header,
    required this.item,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width ?? 85,
          child: Text(
            header,
            style: TxtStyle.H3,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: item,
        ),
      ],
    );
  }
}
