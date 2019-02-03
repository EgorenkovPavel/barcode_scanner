import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import './objects/flower.dart';
import './ConnectionSettings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainModel extends Model{

  Map<String, Flower> _flowers = {};

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

    var response;
    try {
      response = await http.get(
          ConnectionSettings.serverPath + 'price?barcode=$barcode',
          headers: ConnectionSettings.headers);
    }catch(e){
      return null;
    }

    if (response.statusCode != 200) {
      return null;
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
        fixPrice: map['fixPrice']);

    _flowers[barcode] = flower;

    return flower;
  }
}