import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/dialog.dart';
import 'package:topgo_web/widgets/input.dart';
import 'package:provider/provider.dart';

class CancelDialog extends StatefulWidget {
  final Order order;
  final void Function() onChoose;
  const CancelDialog({Key? key, required this.order, required this.onChoose})
      : super(key: key);

  @override
  _CancelDialogState createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  late TextEditingController comment;

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      width: 415,
      height: 150,
      closeButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 22),
            Input(
              text: 'Комментарий',
              multilined: true,
              controller: comment,
            ),
            Spacer(),
            Text('По вине:', style: TxtStyle.H3),
            SizedBox(height: 8),
            Row(
              children: [
                Button(
                  text: 'Курьера',
                  buttonType: ButtonType.Accept,
                  onPressed: () async => {
                    if (widget.order.deliverySum != -1)
                      {
                        await context.read<Restaurant>().orderCancel(
                            context,
                            widget.order,
                            OrderFaultType.ByCourier,
                            comment.text),
                        widget.onChoose(),
                        Navigator.pop(context),
                      }
                  },
                ),
                SizedBox(width: 8),
                Button(
                  text: 'Ресторана',
                  buttonType: ButtonType.Decline,
                  onPressed: () async => {
                    if (widget.order.deliverySum != -1)
                      {
                        await context.read<Restaurant>().orderCancel(
                            context,
                            widget.order,
                            OrderFaultType.ByRestaurant,
                            comment.text),
                        widget.onChoose(),
                        Navigator.pop(context),
                      }
                  },
                ),
              ],
            ),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
