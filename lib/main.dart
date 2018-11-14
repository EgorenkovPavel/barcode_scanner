import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'dart:async';
import 'dart:convert';

import './widgets/flowers_card.dart';
import './widgets/start_page.dart';
import './objects/flower.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget body = Text('Scan!');

  Flower flower = Flower(
      title: 'Rose',
      barcode: '2345323452345',
      description: 'L-40',
      genus: 'genus',
      type: 'type',
      variety: 'variety',
      country: 'Poland',
      color: 'blue',
      regularPrice: 12.4,
      photoPath:
          'https://www.flyingflowers.co.uk/ff_images/product/8466/FC93621F.jpg?large',
      delicious: true,
      sale: true,
      premium: true,
      fixPrice: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Price checker'),
        ),
        body: StartPage(null),//FlowerCard(flower),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.photo_camera),
            onPressed: () {
              start().then((Widget value) {
                setState(() {
                  body = value;
                });
              });
            }),
      ),
    );
  }

  Future<Widget> start() async {
    bool isConnected = await isConnectedToNetwork();
    if (!isConnected) {
      return Text('Check internet connection');
    }

    String barcode = await scan();
    if (barcode.isEmpty) {
      return Text('Scan');
    }

    Flower flower = await getGoodInfo(barcode);

    }

  Future<bool> isConnectedToNetwork() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
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

  Future<Flower> getGoodInfo(String barcode) async {
    final response =
        await http.get('http://appapi.ru:7000/barcode?barcode=$barcode');

    if(response.statusCode != 200){
      return null;
    }

//    Map<String, dynamic> map = json.decode(response.body);

//    double price = 0.0;
//    if(map["price"] is double){
//      price = map["price"];
//    }else if (map["price"] is int){
//      price = price + map["price"];
//    }


    return null;//response.body;
  }
}
