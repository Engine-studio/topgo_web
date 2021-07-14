import 'package:flutter/widgets.dart';

class ClrStyle {
  static const Color lightBackground = const Color(0xFFFDFDFD);
  static const Color darkBackground = const Color(0xFFEEEDED);
  static const Color lightPanel = const Color(0xFF6AA5D7);
  static const Color lightPanel_light = const Color(0x266AA5D7);
  static const Color darkPanel = const Color(0xFF6788DA);
  static const Color darkPanel_light = const Color(0x266788DA);
  static const Color lightDecline = const Color(0xFFFF8C82);
  static const Color darkDecline = const Color(0xFFFE6250);
  static const Color lightAccept = const Color(0xFF96D35F);
  static const Color darkAccept = const Color(0xFF76BB40);
  static const Color lightSelect = const Color(0xFFFECB3E);
  static const Color darkSelect = const Color(0xFFFEB43F);
  static const Color lightButton = const Color(0xFF937FF5);
  static const Color darkButton = const Color(0xFF735CE6);
  static const Color lightWave = const Color(0xFF16A7D8);
  static const Color darkWave = const Color(0xFF1290B4);
  static const Color text = const Color(0xFF31477B);
  static const Color icons = const Color(0xFF31477B);
  static const Color dropShadow = const Color(0x266A9DD9);
}

class TxtStyle {
  static const TextStyle H1 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: ClrStyle.text,
  );
  static const TextStyle H2 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: ClrStyle.text,
  );
  static const TextStyle H3 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 17,
    color: ClrStyle.text,
  );
  static const TextStyle H4 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: ClrStyle.text,
  );
  static const TextStyle H5 = const TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: ClrStyle.text,
  );
  static const TextStyle Text = const TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: ClrStyle.text,
  );
  static const TextStyle h2 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: ClrStyle.text,
  );
  static const TextStyle h3 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: ClrStyle.text,
  );
  static const TextStyle h4 = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: ClrStyle.text,
  );
  static const TextStyle Alert = const TextStyle(
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: ClrStyle.text,
  );
}

class GrdStyle {
  static const LinearGradient panel = const LinearGradient(colors: [
    ClrStyle.lightPanel,
    ClrStyle.darkPanel,
  ]);
  static const LinearGradient lightPanel = const LinearGradient(colors: [
    ClrStyle.lightPanel_light,
    ClrStyle.darkPanel_light,
  ]);
  static const LinearGradient decline = const LinearGradient(colors: [
    ClrStyle.lightDecline,
    ClrStyle.darkDecline,
  ]);
  static const LinearGradient accept = const LinearGradient(colors: [
    ClrStyle.lightAccept,
    ClrStyle.darkAccept,
  ]);
  static const LinearGradient select = const LinearGradient(colors: [
    ClrStyle.lightSelect,
    ClrStyle.darkSelect,
  ]);
  static const LinearGradient button = const LinearGradient(colors: [
    ClrStyle.lightButton,
    ClrStyle.darkButton,
  ]);
  static const LinearGradient wave = const LinearGradient(colors: [
    ClrStyle.lightWave,
    ClrStyle.darkWave,
  ]);
}
