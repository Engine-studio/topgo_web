import 'package:flutter/material.dart';
import 'package:topgo_web/border_box.dart';
import 'package:topgo_web/courier_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center (
        child: Padding(
          padding: const EdgeInsets.only(top: 26, left: 30, right: 30, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Spacer(flex: 26,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 702,
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(color: Colors.red)
                    )
                  ),
                  Spacer(flex: 24),
                  Flexible(
                    flex: 208,
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(color: Colors.green)
                    ),
                  ),
                  Spacer(flex: 24),
                  Flexible(
                    flex: 182,
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(color: Colors.blue)
                    ),
                  ),
                ],
              ),
              //Spacer(flex: 24,),
              SizedBox(height: 24,),
              Flexible(
                flex: 715,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 475,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        radius: Radius.circular(10),
                        child: ListView(
                          children: [
                            CourierBox(),
                            SizedBox(height: 16,),
                            CourierBox(),
                            SizedBox(height: 16,),
                            CourierBox(),
                            SizedBox(height: 16,),
                            CourierBox(),
                            SizedBox(height: 16,),
                            CourierBox(),
                          ],
                        ),
                      ),
                      // child: Container(
                      //   decoration: BoxDecoration(color: Colors.yellow)
                      // ),
                    ),
                    Spacer(flex: 24,),
                    Flexible(
                      flex: 641,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.purple)
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
