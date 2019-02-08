import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import './ConnectionSettings.dart';
import './objects/flower.dart';

class MainModel extends Model{

  bool _connected;

  Map<String, Flower> _flowers = {};
  var _flowerList = [];

  connected(bool value) {
    _connected = value;
  }

  Map<String, Flower> get flowers => _flowers;

  get flowerList => _flowerList;

  Future<String> scanBarcodeOnCamera() async {
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

  Future<Flower> getFlower(String barcode) async {

    if(_flowers[barcode] != null){
      return _flowers[barcode];
    }

    if(!_connected){
      throw Exception('No internet connection. Connect to internet and try again');
    }

    var response;
    try {
        var body = json.encode({'barcode': barcode});
        Map<String, String> headers = {'Content-Type': 'application/json'};
        response = await http.post(ConnectionSettings.serverPath, body: body, headers: headers);
    }catch(e){
      throw Exception('Connection error. Check internet connection');
    }

    if (response.statusCode != 200) {
      throw Exception('Server error. Try later');
    }

    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));

    final Flower flower = Flower(
        title: map['title'],
        barcode: map['barcode'],
        description: map['description'],
        genus: map['genus'],
        type: map['type'],
        variety: map['variety'],
        country: map['country'],
        color: map['color'],
        regularPrice: map['regularPrice'].toDouble(),
        photoPath: map['photoPath'],
        delicious: map['delicious'],
        sale: map['action'],
        premium: map['premium'],
        fixPrice: true);//map['fixPrice']);

    _flowers[barcode] = flower;
    _flowerList.insert(0, flower);
    notifyListeners();

    return flower;
  }


}