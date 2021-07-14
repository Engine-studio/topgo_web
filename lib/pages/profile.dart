import 'package:flutter/widgets.dart';
import 'package:topgo_web/functions/phone_string.dart';
import 'package:topgo_web/widgets/border_box.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/functions/time_string.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/address_holder.dart';
import 'package:topgo_web/widgets/map/map.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Restaurant self = context.read<Restaurant>();
    return Column(
      children: [
        SizedBox(height: 32),
        Text('Профиль', style: TxtStyle.H1),
        SizedBox(height: 38),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: main.fullSize ? 30 : 24),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AbsorbPointer(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    margin: EdgeInsets.only(left: main.fullSize ? 367 : 179),
                    child: Map(
                      center: self.location,
                      markers: [MapMarker.restaurant(self)],
                    ),
                  ),
                ),
                BorderBox(
                  height: 305,
                  width: 426,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text(
                          '"${self.name}"',
                          style: TxtStyle.H1,
                        ),
                        Spacer(flex: 40),
                        TextHolder(
                          header: Text('Адрес:', style: TxtStyle.H3),
                          address: Text(
                            self.address ?? 'No data',
                            style: TxtStyle.Text,
                          ),
                        ),
                        Spacer(flex: 16),
                        TextHolder(
                          header: Text('Время работы:', style: TxtStyle.H3),
                          address: Text(
                            timeString(self.open ?? [0, 0]) +
                                '  -  ' +
                                timeString(self.close ?? [0, 0]),
                            style: TxtStyle.Text,
                          ),
                          placement: Alignment.centerLeft,
                        ),
                        Spacer(flex: 16),
                        TextHolder(
                          header: Text('Телефон:', style: TxtStyle.H3),
                          address: Text(
                            phoneString(self.phone ?? '00000000000'),
                            style: TxtStyle.Text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 62),
      ],
    );
  }
}
