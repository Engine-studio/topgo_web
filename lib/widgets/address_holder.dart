import 'package:flutter/widgets.dart';

class TextHolder extends StatelessWidget {
  final Alignment? placement;
  final Text header, address;
  const TextHolder({
    Key? key,
    required this.header,
    required this.address,
    this.placement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 85,
          child: header,
        ),
        SizedBox(width: 10),
        Expanded(
          child: address,
        ),
      ],
    );
  }
}
