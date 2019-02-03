import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../ConnectionSettings.dart';
import '../Localization.dart';
import '../MainModel.dart';
import '../objects/flower.dart';

class FlowerPage extends StatefulWidget {
  final String barcode;
  final Function getFlower;
  String errorMessage;

  FlowerPage(this.barcode, this.getFlower);

  @override
  State<StatefulWidget> createState() {
    return FlowerPageState();
  }
}

enum Status { SUCCESS, ERROR, LOADING }

class FlowerPageState extends State<FlowerPage> {
  Status _status;
  Flower _flower;
  String _errorMessage;

  @override
  void initState() {
    getGoodInfo(widget.barcode);
    super.initState();
  }

  void getGoodInfo(String barcode) async {
    setState(() {
      _status = Status.LOADING;
    });

    Flower flower = null;
    try {
      flower = await widget.getFlower(widget.barcode);
    }catch(e){
      setState(() {
        _errorMessage = e.toString();
        _status = Status.ERROR;
      });
      return;
    }

    setState(() {
      _flower = flower;
      if(flower == null){
        _status = Status.ERROR;
      }else{
        _status = Status.SUCCESS;
      }
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

  Widget _bodyWidget() {
    if (_status == Status.LOADING) {
      return Center(child: CircularProgressIndicator());
    } else if (_status == Status.ERROR) {
      return Center(child: Text(_errorMessage));
    }

    return ListView(
      children: <Widget>[
        FadeInImage(
          placeholder: AssetImage('assets/sample_product.png'),
          image: NetworkImage(_flower.photoPath,
              headers: ConnectionSettings.headers),
          height: 300.0,
          fit: BoxFit.cover,
        ),
        Center(
          child: Text(
            _flower.title,
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
        ),
        _tagBar(),
        _priceTag(),
        _valueWidget(AppLocalizations.of(context).barcode, _flower.barcode),
        _valueWidget(
            AppLocalizations.of(context).description, _flower.description),
        _valueWidget(AppLocalizations.of(context).genus, _flower.genus),
        _valueWidget(AppLocalizations.of(context).type, _flower.type),
        _valueWidget(AppLocalizations.of(context).variety, _flower.variety),
        _valueWidget(AppLocalizations.of(context).country, _flower.country),
        _valueWidget(AppLocalizations.of(context).color, _flower.color),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).priceChecker),
          ),
          body: _bodyWidget(),
          floatingActionButton: FloatingActionButton(
              child: Image.asset("assets/barcode-scan.png"),
              onPressed: () {
                model.scanBarcodeOnCamera().then((String barcode) {
                  if (barcode.isEmpty) return;
                  Navigator.pushReplacementNamed(context, '/flowers/$barcode');
                });
              }),
        );
      },
    );
   }
}
