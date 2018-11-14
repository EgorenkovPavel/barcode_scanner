import 'package:flutter/material.dart';

import '../objects/flower.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;

  FlowerCard(this.flower);

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
          _tag(flower.delicious, 'Delicious'),
          _tag(flower.sale, 'Sale'),
          _tag(flower.premium, 'Premium')
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Image.network(flower.photoPath),
        Center(
          child: Text(
            flower.title,
            style: TextStyle(fontSize: 20),
          ),
        ),
        _tagBar(),
        _priceTag(flower.regularPrice.toString()),
        _valueWidget('Barcode', flower.barcode),
        _valueWidget('Description', flower.description),
        _valueWidget('Genus', flower.genus),
        _valueWidget('Type', flower.type),
        _valueWidget('Variety', flower.variety),
        _valueWidget('Country', flower.country),
        _valueWidget('Color', flower.color),
      ],
    );
  }
}
