import 'package:flutter/material.dart';
//TODO: change text styles

class Input extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool multilined;

  const Input({
    Key? key,
    required this.text,
    required this.controller,
    this.multilined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: multilined ? 104 : 44,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A9DD9).withOpacity(0.15),
            blurRadius: 3,
          )
        ],
      ),
      child: TextField(
        controller: this.controller,
        obscureText: this.text == 'Пароль',
        //style: TxtStyle.selectedMainText,
        cursorColor: Colors.black,
        maxLines: multilined ? null : 1,
        decoration: InputDecoration(
          //hintStyle: TxtStyle.mainText,
          hintText: this.text,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        ),
      ),
    );
  }
}
