import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/api.dart';
import 'package:topgo_web/main.dart' as main;
import 'package:topgo_web/models/order.dart';
import 'package:topgo_web/models/restaurant.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/create_alert.dart';
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
  bool? bigOrder;
  OrderPayment? payment;
  late MaskedTextController phone;
  late TextEditingController body, sum, address, timeH, timeM, comment;

  @override
  void initState() {
    // TODO: implement initState, button function
    super.initState();
    sum = TextEditingController();
    body = TextEditingController();
    address = TextEditingController();
    timeH = TextEditingController();
    timeM = TextEditingController();
    comment = TextEditingController();
    phone = MaskedTextController(mask: "+0 (000) 000-00-00");
  }

  @override
  Widget build(BuildContext context) {
    String number;
    LatLng? toLatLng;
    double deliverySumRub;
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
                          controller: body,
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Крупный заказ:',
                        item: RadioChoose(
                          text: ['Да', 'Нет'],
                          change: (str) {
                            if (str != null) {
                              bigOrder = str == 'Да';
                            }
                          },
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Адрес доставки:',
                        item: Input(
                          text: 'Введите адрес доставки',
                          multilined: true,
                          controller: address,
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Способ оплаты:',
                        item: RadioChoose(
                          text: ['Наличные', 'Терминал', 'Уже оплачен'],
                          change: (str) {
                            if (str != null) {
                              payment = str == 'Наличные'
                                  ? OrderPayment.Cash
                                  : str == 'Терминал'
                                      ? OrderPayment.Terminal
                                      : OrderPayment.Payed;
                            }
                          },
                        ),
                        width: 190,
                      ),
                      ItemHolder(
                        header: 'Сумма заказа:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Input(money: true, controller: sum),
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
                            SizedBox(
                              width: 35,
                              child: Input(controller: timeH),
                            ),
                            SizedBox(width: 8),
                            Text('час', style: TxtStyle.H5),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 35,
                              child: Input(controller: timeM),
                            ),
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
                          controller: comment,
                        ),
                        width: 190,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: main.fullSize ? 564 : 300,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Map(
                      center: self.latLng,
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
            onPressed: () async => {
              number = phone.text,
              for (String str in ['+', '(', ')', '-', ' '])
                number = number.replaceAll(str, ''),
              if (number.length == 11 &&
                  address.text != '' &&
                  body.text != '' &&
                  comment.text != '' &&
                  double.tryParse(sum.text.replaceAll(' ', '')) != null &&
                  bigOrder != null &&
                  payment != null &&
                  int.tryParse(timeH.text) != null &&
                  int.tryParse(timeM.text) != null)
                {
                  toLatLng = await getLatLng(context, address.text),
                  deliverySumRub = toLatLng != null
                      ? await deliverySum(context, bigOrder!, toLatLng!)
                      : -1,
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                        value: Provider.of<Restaurant>(context, listen: false),
                        child: CreateDialog(
                          order: Order.create(
                            toAddress: address.text,
                            clientPhone: number,
                            body: body.text,
                            comment: comment.text,
                            sum: double.parse(sum.text.replaceAll(' ', '')),
                            big: bigOrder,
                            paymentType: payment,
                            cookingTime: [
                              int.parse(timeH.text),
                              int.parse(timeM.text),
                            ],
                            deliverySum: deliverySumRub,
                          ),
                        ),
                      );
                    },
                  ),
                },
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
