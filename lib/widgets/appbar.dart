import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/main.dart' as main;

class Appbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final void Function(int) onTap;

  Appbar({Key? key, required this.onTap})
      : preferredSize = Size.fromHeight(50),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Image.asset('assets/images/logo.png'),
            Spacer(),
            SizedBox(
              height: 24,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onTap(0),
                    child: Text(
                      'Главная',
                      style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  SizedBox(width: main.fullSize ? 80 : 40),
                  GestureDetector(
                    onTap: () => onTap(1),
                    child: Text(
                      'Оформить заказ',
                      style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  SizedBox(width: main.fullSize ? 80 : 40),
                  GestureDetector(
                    onTap: () => onTap(2),
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
                              Center(child: Text('14', style: TxtStyle.Alert)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: main.fullSize ? 80 : 40),
                  GestureDetector(
                    onTap: () => onTap(3),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/user-circle.png', height: 22),
                        SizedBox(width: 10),
                        Text(
                          'Такой-то ресторан',
                          style: TxtStyle.H4.copyWith(color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
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
