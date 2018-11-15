import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../objects/flower.dart';

class FlowerCard extends StatefulWidget {
  final String barcode;

  FlowerCard(this.barcode)

  @override
  State<StatefulWidget> createState() {
    return FlowerCardState();
  }
}

class FlowerCardState extends State<FlowerCard>{

  bool _isLoading;
  Flower _flower;

  @override
  void initState() {
    getGoodInfo(widget.barcode);
    super.initState();
  }

  void getGoodInfo(String barcode) async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, String> headers = {'Authorization': 'Basic dXNlcjo='};

    final response = await http.get(
        'http://msavelev/UT11_PE/ru_RU/hs/pricechecker/price?barcode=$barcode',
        headers: headers);

    if (response.statusCode != 200) {
      return;
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
    });
  }

  Widget _valueWidget(String title, String value) {
    if(value.isEmpty){
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }

  Widget _priceTag(String price) {
    return Center(
      child: Container(
        color: Colors.orange,
        child: Text(
          '${price} ₽',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
    );
  }

  Widget _tagBar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _tag(_flower.delicious, 'Delicious'),
          _tag(_flower.sale, 'Sale'),
          _tag(_flower.premium, 'Premium')
        ],
      ),
    );
  }

  Widget _tag(bool value, String text) {
    if (value)
      return Container(
        margin: EdgeInsets.all(4.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    else
      return SizedBox();
  }

  Widget _bodyWidget(){
    if(_isLoading || _flower == null){
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: <Widget>[
        Image.network(_flower.photoPath),
        Center(
          child: Text(
            _flower.title,
            style: TextStyle(fontSize: 20),
          ),
        ),
        _tagBar(),
        _priceTag(_flower.regularPrice.toString()),
        _valueWidget('Barcode', _flower.barcode),
        _valueWidget('Description', _flower.description),
        _valueWidget('Genus', _flower.genus),
        _valueWidget('Type', _flower.type),
        _valueWidget('Variety', _flower.variety),
        _valueWidget('Country', _flower.country),
        _valueWidget('Color', _flower.color),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Price checker'),),
        body: _bodyWidget()
    );
  }
}
