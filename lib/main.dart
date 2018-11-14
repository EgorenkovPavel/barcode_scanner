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

void main() => runApp(MyApp());

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

  MyAppState(){
    _isLoading = true;
    checkConnection();
  }

  Widget _getBodyWidget(){
        if (_isLoading){
          return LoadingPage();
        }else if(_isError){
          return ErrorPage(_errorText);
        }else if(_flower != null){
          return FlowerCard(_flower);
        }else{
          return StartPage(scan, getGoodInfo);
        };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Price checker'),
        ),
        body: _getBodyWidget(),
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

  void scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      getGoodInfo(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        return ; //'The user did not grant the camera permission!';
      } else {
        return ; //'Unknown error: $e');
      }
    } on FormatException {
      return ; //'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      return ; //'Unknown error: $e');
    }
  }

  void getGoodInfo(String barcode) async {

    final Map<String, String> headers = {
      'Authorization': 'Basic dXNlcjo='
    };

    final response =
        await http.get('http://msavelev/UT11_PE/ru_RU/hs/pricechecker/price?barcode=$barcode',
        headers: headers);

    if(response.statusCode != 200){
      return ;
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

    setState(() {
      _flower = flower;
      _isLoading = false;
      _isError = false;
    });

  }
}
