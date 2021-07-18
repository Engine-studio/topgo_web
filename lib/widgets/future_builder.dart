import 'package:flutter/widgets.dart';
import 'package:topgo_web/api/alerts.dart';
import 'package:topgo_web/widgets/error.dart';
import 'package:topgo_web/widgets/loading.dart';

class TopGoFutureBuilder extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? future;
  const TopGoFutureBuilder({
    Key? key,
    required this.child,
    this.future,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAlerts(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Error(text: snapshot.error!.toString());
        return snapshot.connectionState == ConnectionState.done
            ? child
            : Loading();
      },
    );
  }
}
