import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/input.dart';
import 'package:topgo_web/widgets/item_holder.dart';
import 'package:topgo_web/widgets/map/map.dart';
import 'package:provider/provider.dart';
import 'package:topgo_web/widgets/map/map_marker.dart';
import 'package:topgo_web/widgets/radio.dart';

class DeliveryTab extends StatefulWidget {
  const DeliveryTab({Key? key}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  late MaskedTextController phone;
  late TextEditingController deliverySum;

  @override
  void initState() {
    // TODO: implement initState, button function
    super.initState();
    deliverySum = TextEditingController();
    phone = MaskedTextController(mask: "+0 (000) 000-00-00");
  }

  @override
  Widget build(BuildContext context) {
    Restaurant self = context.read<Restaurant>();
    return Column(
      children: [
        SizedBox(height: 24),
        Text('Форма для оформления доставки', style: TxtStyle.H1),
        SizedBox(height: 24),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: main.fullSize ? 30 : 24),
            child: Row(
              children: [
                Expanded(
                  flex: main.fullSize ? 560 : 404,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ItemHolder(
                        header: 'Состав заказа:',
                        item: Input(
                          text: 'Введите состав заказа',
                          multilined: true,
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Крупный заказ:',
                        item: RadioChoose(text: ['Да', 'Нет']),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Адрес доставки:',
                        item: Input(
                          text: 'Введите адрес доставки',
                          multilined: true,
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Стоимость доставки:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child:
                                  Input(money: true, controller: deliverySum),
                            ),
                            SizedBox(width: 8),
                            Text('рублей', style: TxtStyle.H5),
                          ],
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Способ оплаты:',
                        item: RadioChoose(
                          text: ['Наличные', 'Терминал', 'Уже оплачен'],
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Сумма заказа:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Input(money: true),
                            ),
                            SizedBox(width: 8),
                            Text('рублей', style: TxtStyle.H5),
                          ],
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Время готовки:',
                        item: Row(
                          children: [
                            SizedBox(width: 35, child: Input()),
                            SizedBox(width: 8),
                            Text('час', style: TxtStyle.H5),
                            SizedBox(width: 8),
                            SizedBox(width: 35, child: Input()),
                            SizedBox(width: 8),
                            Text('минут', style: TxtStyle.H5),
                          ],
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Телефон клиента:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Input(maskedController: phone),
                            ),
                          ],
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Комментарий:',
                        item: Input(
                          text: 'Ваш комментарий к заказу',
                          multilined: true,
                        ),
                        width: 190,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: main.fullSize ? 564 : 300,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Map(
                      center: self.location,
                      markers: [MapMarker.restaurant(self)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 250,
          child: Button(
            text: 'Оформить',
            buttonType: ButtonType.Panel,
            onPressed: () async => {},
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
