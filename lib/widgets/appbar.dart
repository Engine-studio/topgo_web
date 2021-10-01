import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/main.dart' as main;

class Appbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final void Function(int, BuildContext) onTap;

  Appbar({Key? key, required this.onTap})
      : preferredSize = Size.fromHeight(50),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _list = ['Профиль', 'История заказов', 'Выход'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: GrdStyle.panel,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: 30, top: 7, bottom: 7, right: main.fullSize ? 80 : 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => onTap(0, context),
              child: Image.asset('assets/images/logo.png'),
            ),
            Spacer(),
            SizedBox(
              height: 24,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(1, context),
                    child: Text(
                      'Оформить заказ',
                      style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  SizedBox(width: main.fullSize ? 80 : 40),
                  GestureDetector(
                    onTap: () => onTap(2, context),
                    child: Row(
                      children: [
                        Text(
                          'Уведомления',
                          style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Stack(
                            children: [
                              Image.asset('assets/icons/alert_bg.png',
                                  height: 24),
                              Image.asset('assets/icons/alert.png', height: 24),
                              Center(
                                child: Text(
                                  context
                                      .watch<Restaurant>()
                                      .alertsCount
                                      .toString(),
                                  style: TxtStyle.Alert,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: main.fullSize ? 80 : 40),
                  PopupMenuButton(
                    padding: const EdgeInsets.all(0),
                    offset: Offset(0, 35),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/user-circle.png', height: 22),
                        SizedBox(width: 10),
                        Text(
                          context.read<Restaurant>().name ?? "Ваш ресторан",
                          style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: ClrStyle.darkPanel),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    enabled: true,
                    onSelected: (value) =>
                        onTap(3 + (int.parse(value.toString())), context),
                    itemBuilder: (context) => _list
                        .map(
                          (str) => PopupMenuItem(
                            value: _list.indexOf(str),
                            child: Row(
                              children: [
                                Text(str, style: TxtStyle.H4),
                                ...str == 'Выход'
                                    ? [
                                        SizedBox(width: 8),
                                        Image.asset(
                                          'assets/icons/log-in.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ]
                                    : [],
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
