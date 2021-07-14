import 'package:flutter/widgets.dart';

//TODO: change text styles
class AddressHolder extends StatelessWidget {
  final String dist, address;
  const AddressHolder({
    Key? key,
    required this.dist,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 45,
          alignment: Alignment.topLeft,
          child: Text(dist),
        ),
        Expanded(
          child: Container(
            height: 45,
            child: Text(address),
          ),
        ),
      ],
    );
  }
}
