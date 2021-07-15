import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/widgets/dialog.dart';
import 'package:topgo_web/widgets/rate_courier.dart';

class GradingDialog extends StatelessWidget {
  const GradingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      width: 415,
      height: 258,
      closeButton: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RateCourier(),
      ),
    );
  }
}
