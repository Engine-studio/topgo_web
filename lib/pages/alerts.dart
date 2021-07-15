import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/widgets/grading_dialog.dart';

class AlertsTab extends StatefulWidget {
  const AlertsTab({Key? key}) : super(key: key);

  @override
  _AlertsTabState createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return ChangeNotifierProvider.value(
              value: Provider.of<Restaurant>(context, listen: false),
              child: GradingDialog(),
            );
          },
        ),
        child: Container(width: 100, height: 30, color: Colors.red),
      ),
    );
  }
}
