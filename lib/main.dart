import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'dart:async';
import 'dart:convert';

import './widgets/flowers_card.dart';
import './widgets/start_page.dart';
import './widgets/loading_page.dart';
import './widgets/error_page.dart';
import './objects/flower.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool _isLoading = false;
  bool _isError = false;
  Flower _flower;
  String _errorText;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller =
      TextEditingController(text: '5500009866193');

  MyAppState() {
    _isLoading = true;
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price checker'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Image.asset('assets/logo7fl.jpg')),
          Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(labelText: 'Enter barcode'),
                        maxLength: 13,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.length < 13) {
                            return 'Barcode has length 13 symbols';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: 16.0,
          ),
          RaisedButton(
            child: Text(
              'Search',
              style: Theme.of(context).textTheme.button,

            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                getGoodInfo(controller.text).then((Flower flower) {
                  if(flower == null) return;
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return FlowerCard(flower);
                  }));
                });
              }
            },
          ),

          RaisedButton(
            child: Text(
              'Scan',
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              scan().then((Flower flower){
                if(flower == null) return;
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return FlowerCard(flower);
                    }));
              });
            },
          )
        ],
      ),
    );
  }

  void checkConnection() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _errorText = "No connection. Check the internet";
      });
    } else {
      setState(() {
        _isError = false;
        _isLoading = false;
        _errorText = '';
      });
    }
  }

  Future<Flower> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return getGoodInfo(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        return null; //'The user did not grant the camera permission!';
      } else {
        return null; //'Unknown error: $e');
      }
    } on FormatException {
      return null; //'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      return null; //'Unknown error: $e');
    }
  }

  Future<Flower> getGoodInfo(String barcode) async {
    final Map<String, String> headers = {'Authorization': 'Basic dXNlcjo='};

    final response = await http.get(
        'http://msavelev/UT11_PE/ru_RU/hs/pricechecker/price?barcode=$barcode',
        headers: headers);

    if (response.statusCode != 200) {
      return null;
    }

    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));

    Flower flower = Flower(
        title: map['title'],
        barcode: map['barcode'],
        description: map['description'],
        genus: map['genus'],
        type: map['type'],
        variety: map['variety'],
        country: map['country'],
        color: map['color'],
        regularPrice: map['regularPrice'],
        photoPath: map['photoPath'],
        delicious: map['delicious'],
        sale: map['sale'],
        premium: map['premium'],
        fixPrice: map['fixPrice']);

    return flower;

    setState(() {
      _flower = flower;
      _isLoading = false;
      _isError = false;
    });
  }
}
