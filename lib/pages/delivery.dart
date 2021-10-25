import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:topgo_web/api.dart' as api;
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

bool validAddress(
  TextEditingController city,
  TextEditingController street,
  TextEditingController building,
) {
  return city.text != '' && street.text != '' && building.text != '';
}

String getAddress(
    TextEditingController city,
    TextEditingController street,
    TextEditingController building,
    TextEditingController door,
    TextEditingController floor,
    TextEditingController flat,
    {bool? forQuery}) {
  return forQuery == true
      ? "${city.text}, ${street.text}, ${building.text}"
      : "Россия, город ${city.text}, улица ${street.text}, " +
          "дом ${building.text}" +
          (door.text != '' ? ', ${door.text} подъезд' : '') +
          (floor.text != '' ? ', ${floor.text} этаж' : '') +
          (flat.text != '' ? ', кв./офис ${flat.text}' : '');
}

class DeliveryTab extends StatefulWidget {
  final Function() redirect;
  const DeliveryTab({Key? key, required this.redirect}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  bool? bigOrder;
  OrderPayment? payment;
  late MaskedTextController phone, timeH, timeM;
  late TextEditingController body, sum, comment;
  late TextEditingController city, street, building;
  late TextEditingController floor, door, flat;

  String? number;
  int? hours;
  int? min;

  bool validBigOrder = true,
      validPayment = true,
      validPhone = true,
      validTimeH = true,
      validTimeM = true,
      validBody = true,
      validSum = true,
      validCity = true,
      validStreet = true,
      validBuilding = true;

  void validate() {
    setState(() {
      number = phone.text;
      for (String str in ['+', '(', ')', '-', ' '])
        number = number!.replaceAll(str, '');

      hours = int.tryParse(timeH.text);
      min = int.tryParse(timeM.text);

      validBigOrder = bigOrder != null;
      validPayment = payment != null;
      validPhone = number!.length == 11;
      validTimeH = hours != null && hours! < 24 && hours! >= 0;
      validTimeM = min != null && min! < 60 && min! >= 0;
      validBody = body.text != '';
      validSum = double.tryParse(sum.text.replaceAll(' ', '')) != null;
      validCity = city.text != '';
      validStreet = street.text != '';
      validBuilding = building.text != '';
    });
  }

  bool isValid() {
    return validBigOrder &&
        validPayment &&
        validPhone &&
        validTimeH &&
        validTimeM &&
        validBody &&
        validSum &&
        validCity &&
        validStreet &&
        validBuilding;
  }

  @override
  void initState() {
    super.initState();
    sum = TextEditingController();
    body = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    building = TextEditingController();
    floor = TextEditingController();
    door = TextEditingController();
    flat = TextEditingController();
    timeH = MaskedTextController(mask: "00");
    timeM = MaskedTextController(mask: "00");
    comment = TextEditingController();
    phone = MaskedTextController(mask: "+0 (000) 000-00-00");
  }

  @override
  Widget build(BuildContext context) {
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
                          error: !validBody,
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Крупный заказ:',
                        item: RadioChoose(
                          text: ['Да', 'Нет'],
                          error: !validBigOrder,
                          change: (str) {
                            if (str != null) {
                              bigOrder = str == 'Да';
                            }
                          },
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Адрес доставки:',
                        item: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 13,
                                  child: Input(
                                    text: 'город',
                                    controller: city,
                                    error: !validCity,
                                  ),
                                ),
                                Spacer(flex: 1),
                                Flexible(
                                  flex: 13,
                                  child: Input(
                                    text: 'улица',
                                    controller: street,
                                    error: !validStreet,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
                                  flex: 8,
                                  child: Input(
                                    text: 'дом',
                                    controller: building,
                                    error: !validBuilding,
                                  ),
                                ),
                                Spacer(flex: 1),
                                Flexible(
                                  flex: 8,
                                  child: Input(
                                    text: 'под.',
                                    controller: door,
                                    numericOnly: true,
                                  ),
                                ),
                                Spacer(flex: 1),
                                Flexible(
                                  flex: 8,
                                  child: Input(
                                    text: 'этаж',
                                    controller: floor,
                                    numericOnly: true,
                                  ),
                                ),
                                Spacer(flex: 1),
                                Flexible(
                                  flex: 8,
                                  child: Input(
                                    text: 'кв./офис',
                                    controller: flat,
                                    numericOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Способ оплаты:',
                        item: RadioChoose(
                          text: ['Наличные', 'Терминал', 'Уже оплачен'],
                          error: !validPayment,
                          change: (str) {
                            if (str != null) {
                              payment = str == 'Наличные'
                                  ? OrderPayment.Cash
                                  : str == 'Терминал'
                                      ? OrderPayment.Card
                                      : OrderPayment.AlreadyPayed;
                            }
                          },
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Сумма заказа:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Input(
                                money: true,
                                controller: sum,
                                error: !validSum,
                                numericOnly: true,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('рублей', style: TxtStyle.H5),
                          ],
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Время готовки:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 33,
                              child: Input(
                                maskedController: timeH,
                                error: !validTimeH,
                                numericOnly: true,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('час', style: TxtStyle.H5),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 33,
                              child: Input(
                                maskedController: timeM,
                                error: !validTimeM,
                                numericOnly: true,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('минут', style: TxtStyle.H5),
                          ],
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Телефон клиента:',
                        item: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Input(
                                maskedController: phone,
                                error: !validPhone,
                              ),
                            ),
                          ],
                        ),
                        width: 150,
                      ),
                      ItemHolder(
                        header: 'Комментарий:',
                        item: Input(
                          text: 'Ваш комментарий к заказу',
                          multilined: true,
                          controller: comment,
                        ),
                        width: 150,
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
              validate(),
              if (isValid())
                {
                  toLatLng = await api.getLatLng(
                      context,
                      getAddress(city, street, building, door, floor, flat,
                          forQuery: true)),
                  deliverySumRub = toLatLng != null
                      ? await api.getDeliverySum(
                          context, bigOrder!, toLatLng!, self.latLng!)
                      : -1,
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                        value: Provider.of<Restaurant>(context, listen: false),
                        child: CreateDialog(
                          redirect: widget.redirect,
                          confirm: (order) async =>
                              await api.createOrder(context, order),
                          order: Order.create(
                            toLatLng: toLatLng,
                            toAddress: getAddress(
                                city, street, building, door, floor, flat),
                            clientPhone: this.number,
                            body: body.text,
                            comment: comment.text,
                            sum: double.parse(sum.text.replaceAll(' ', '')),
                            big: bigOrder,
                            paymentType: payment,
                            cookingTime: [this.hours!, this.min!],
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
