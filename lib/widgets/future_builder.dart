import 'dart:convert' show jsonDecode;

import 'package:flutter/widgets.dart';
import 'package:topgo_web/api.dart';
import 'package:topgo_web/widgets/error.dart';
import 'package:topgo_web/widgets/loading.dart';

class TopGoFutureBuilder extends StatelessWidget {
  final Widget child;
  final Future<void> Function(BuildContext)? future;
  const TopGoFutureBuilder({
    Key? key,
    required this.child,
    this.future,
  }) : super(key: key);

  Future<void> globalFuture(BuildContext context) async {
    // await getAlerts(context);
    if (future != null) await future!(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: globalFuture(context),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Error(
                text: jsonDecode(
                    snapshot.error.toString().replaceFirst('Exception: ', '')),
              )
            : snapshot.connectionState == ConnectionState.done
                ? child
                : Loading();
      },
    );
  }
}
