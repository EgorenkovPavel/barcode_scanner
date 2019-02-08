import 'package:barcode_scanner/objects/flower.dart';
import 'package:flutter/material.dart';

class Price extends StatelessWidget{
  final Flower _flower;
  final double _textSize;

  const Price(this._flower, this._textSize);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color textColor = Theme.of(context).primaryTextTheme.title.color;
    if (_flower.fixPrice) {
      backgroundColor = Theme.of(context).accentColor;
      textColor = Colors.white;
    }

    return  Container(
            margin: EdgeInsets.symmetric(vertical: _textSize/6),
            color: backgroundColor,
            child: Text(
              '${_flower.regularPrice} ₽',
              style: TextStyle(
                  color: textColor, fontSize: _textSize, fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.symmetric(horizontal: _textSize/3, vertical: _textSize/12),
          );

  }

}