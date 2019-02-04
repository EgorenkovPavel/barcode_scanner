import 'package:barcode_scanner/objects/flower.dart';
import 'package:flutter/material.dart';
import '../ConnectionSettings.dart';
import '../Localization.dart';

class FlowerCard extends StatelessWidget{
  final Flower _flower;

  const FlowerCard(this._flower);

  Widget _valueWidget(BuildContext context, String title, String value) {
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

  Widget _priceTag(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color textColor = Theme.of(context).primaryTextTheme.title.color;
    if (_flower.fixPrice) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
    }

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            color: backgroundColor,
            child: Text(
              '${_flower.regularPrice} ₽',
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          ),
          _flower.fixPrice
              ? Text(
            AppLocalizations.of(context).fixPrice,
            style: Theme.of(context).textTheme.caption,
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _tagBar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_premiumTag(), _actionTag()],
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

  Widget _photo(){
    return FadeInImage(
      placeholder: AssetImage('assets/sample_product.png'),
      image: NetworkImage(_flower.photoPath,
          headers: ConnectionSettings.headers),
      //width: 300.0,
      height: 300.0,
      fit: BoxFit.cover,
    );
  }

  Widget _info(BuildContext context){
    return Column(
        children: <Widget>[
        Center(
          child: Text(
            _flower.title,
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
        ),
          _tagBar(),
          _priceTag(context),
        _valueWidget(context, AppLocalizations.of(context).barcode, _flower.barcode),
        _valueWidget(context,
            AppLocalizations.of(context).description, _flower.description),
        _valueWidget(context, AppLocalizations.of(context).genus, _flower.genus),
        _valueWidget(context, AppLocalizations.of(context).type, _flower.type),
        _valueWidget(context, AppLocalizations.of(context).variety, _flower.variety),
        _valueWidget(context, AppLocalizations.of(context).country, _flower.country),
        _valueWidget(context, AppLocalizations.of(context).color, _flower.color),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return ListView(
        children: <Widget>[
          _photo(),
          _info(context),
        ],
      );
    } else {
      return ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                _photo(),
                Flexible(child: _info(context)),
              ],
            ),
          ]
      );
    }
  }

}