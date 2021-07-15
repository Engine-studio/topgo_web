import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:topgo_web/styles.dart';
import 'package:topgo_web/widgets/button.dart';
import 'package:topgo_web/widgets/border_box.dart';

class RateCourier extends StatefulWidget {
  const RateCourier({
    Key? key,
  }) : super(key: key);

  @override
  _RateCourierState createState() => _RateCourierState();
}

enum rateNames{
  Look,
  Talk
}

class _RateCourierState extends State<RateCourier> {
  List<int> rates = [0, 0];

  Widget getStarsWidget(rateNames name)
  {
    List<Widget> list = List.empty(growable: true);
    for(var i = 0; i < 5; i++){    
        if (i < rates[name.index])
          list.add(new GestureDetector(
            onTap: () => setState(() => rates[name.index] = i + 1),
            child: Image.asset("assets/icons/star-full.png", height: 19,),
          ),
          );
        else list.add(new GestureDetector(
            onTap: () => setState(() => rates[name.index] = i + 1),
            child: Image.asset("assets/icons/star.png", height: 19,),
          ),
        );
        if (i < 4) list.add(new SizedBox(width: 8,),);
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,  
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 66, right: 67),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Оцените курьера",
                    style: TxtStyle.H1.copyWith(fontSize: 24),
                    )
                ],
              ),
              Spacer(flex: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Row(children: [
                      Expanded(child: Text("Опрятность и внешений вид", style: TxtStyle.H3.copyWith(fontSize: 14),)),
                      Expanded(child: getStarsWidget(rateNames.Look)),
                    ],),
                    SizedBox(height: 16,),
                    Row(children: [
                      Expanded(child: Text("Культура речи и вежливость", style: TxtStyle.H3.copyWith(fontSize: 14),)),
                      Expanded(child: getStarsWidget(rateNames.Talk),
                      ),
                    ],)
                ],
              ),
              Spacer(flex: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 182,
                    height: 38,
                    child: Button(
                      text: 'Оценить курьера',
                      buttonType: ButtonType.Select,
                      onPressed: () async => {},
                    ),
                  ),
                ],
              )
              
            ],
          ),
        ),
      )
    );
  }
}
