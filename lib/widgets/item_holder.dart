import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';

class ItemHolder extends StatelessWidget {
  final double? width;
  final String header;
  final Widget item;
  final TextStyle? style;
  final bool horizontal;

  const ItemHolder({
    Key? key,
    required this.header,
    required this.item,
    this.width,
    this.style,
    this.horizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width ?? 85,
                child: Text(
                  header,
                  style: style ?? TxtStyle.H3,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: item,
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(header, style: style ?? TxtStyle.H3),
              SizedBox(width: 10),
              item,
            ],
          );
  }
}
