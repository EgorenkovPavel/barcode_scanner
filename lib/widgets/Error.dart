import 'package:barcode_scanner/Localization.dart';
import 'package:barcode_scanner/objects/ScanException.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget{
  final ExceptionType _type;

  const Error(this._type);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Text(AppLocalizations.of(context).errorTitle(_type), style: Theme.of(context).primaryTextTheme.title,),
        Text(AppLocalizations.of(context).errorMessage(_type), style: Theme.of(context).primaryTextTheme.body1,)
      ],
      ),
    );
  }
}