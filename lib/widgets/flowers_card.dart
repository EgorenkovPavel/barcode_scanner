import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../objects/flower.dart';
import '../ConnectionSettings.dart';

class FlowerCard extends StatefulWidget {
  final String barcode;

  FlowerCard(this.barcode);

  @override
  State<StatefulWidget> createState() {
    return FlowerCardState();
  }
}

enum Status { SUCCESS, ERROR, LOADING }

class FlowerCardState extends State<FlowerCard> {
  Status _status;
  Flower _flower;

  @override
  void initState() {
    getGoodInfo(widget.barcode);
    super.initState();
  }

  void getGoodInfo(String barcode) async {
    setState(() {
      _status = Status.LOADING;
    });

    final response = await http.get(
        ConntectionSettings.serverPath + 'price?barcode=$barcode',
        headers: ConntectionSettings.headers);

    if (response.statusCode != 200) {
      setState(() {
        _status = Status.ERROR;
      });
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
        regularPrice: map['regularPrice'].toDouble(),
        photoPath: map['photoPath'],
        delicious: map['delicious'],
        sale: map['sale'],
        premium: map['premium'],
        fixPrice: map['fixPrice']);

    setState(() {
      _flower = flower;
      _status = Status.SUCCESS;
    });
  }

  Widget _valueWidget(String title, String value) {
    if (value.isEmpty) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.body1,
            ),
            flex: 2,
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }

  Widget _priceTag() {
    Color color = Theme.of(context).primaryColor;
    if (_flower.fixPrice) {
      color = Colors.amber;
    }

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        color: color,
        child: Text(
          '${_flower.regularPrice} ₽',
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
        children: <Widget>[_actionTag(), _premiumTag()],
      ),
    );
  }

  Widget _premiumTag() {
    if (_flower.premium) {
      return Image.asset(
        'assets/premium.jpg',
        height: 22,
      );
    } else {
      return SizedBox();
    }
  }

  Widget _actionTag() {
    if (_flower.sale) {
      return Image.asset(
        'assets/action.png',
        height: 22,
      );
    } else {
      return SizedBox();
    }
  }

  Widget _bodyWidget() {
    if (_status == Status.LOADING || _flower == null) {
      return Center(child: CircularProgressIndicator());
    } else if (_status == Status.ERROR) {
      return Center(child: Text('Server error'));
    }

    return ListView(
      children: <Widget>[
        Image.network(_flower.photoPath),
        Center(
          child: Text(
            _flower.title,
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
        ),
        _tagBar(),
        _priceTag(),
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
      appBar: AppBar(
        title: Text('Price checker'),
      ),
      body: _bodyWidget(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.undo),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
