import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:topgo_web/functions/money_string.dart';
import 'package:topgo_web/styles.dart';

class Input extends StatelessWidget {
  final String? text;
  final void Function()? onSubmit;
  final TextEditingController? controller;
  final MaskedTextController? maskedController;
  final bool multilined, money, styling;

  const Input({
    Key? key,
    this.text,
    this.controller,
    this.maskedController,
    this.multilined = false,
    this.money = false,
    this.styling = true,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? tmp;
    return Container(
      height: multilined ? 58 : 29,
      decoration: styling
          ? BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A9DD9).withOpacity(0.15),
                  blurRadius: 3,
                )
              ],
            )
          : BoxDecoration(),
      child: Focus(
        onFocusChange: (hasFocus) => {
          if (money)
            {
              tmp = double.tryParse(controller!.text.replaceAll(' ', '')),
              if (tmp != null) controller!.text = moneyString(tmp!, rub: false)
            }
        },
        child: TextField(
          controller: controller ?? maskedController,
          obscureText: text != null && text == 'Пароль',
          style: TxtStyle.H5,
          cursorColor: Colors.black,
          maxLines: multilined ? null : 1,
          onEditingComplete: onSubmit,
          decoration: InputDecoration(
            hintStyle: TxtStyle.H5.copyWith(
              color: ClrStyle.text.withOpacity(0.7),
            ),
            hintText: text ?? '',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
