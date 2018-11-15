import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import './widgets/flowers_card.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: TextTheme(button: TextStyle(color: Colors.white))),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller =
      TextEditingController(text: '5500009866193');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price checker'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo7fl.jpg'),
              Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: controller,
                            decoration:
                                InputDecoration(labelText: 'Enter barcode'),
                            maxLength: 13,
                            keyboardType: TextInputType.number,
                            validator: (String value) {
                              if (value.length < 13) {
                                return 'Barcode has length 13 symbols';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        RaisedButton(
                          child: Text(
                            'SEARCH',
                            style: Theme.of(context).textTheme.button,
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return FlowerCard(controller.text);
                              }));
                            }
                          },
                        ),
                      ],
                    ),
                  )),
              RaisedButton(
                child: Text(
                  'SCAN',
                  style: Theme.of(context).textTheme.button,
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  scan().then((String barcode) {
                    if (barcode.isEmpty) return;
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return FlowerCard(barcode);
                    }));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        return ''; //'The user did not grant the camera permission!';
      } else {
        return ''; //'Unknown error: $e');
      }
    } on FormatException {
      return ''; //'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      return ''; //'Unknown error: $e');
    }
  }
}
