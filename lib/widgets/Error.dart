import 'package:barcode_scanner/localizations/Localization.dart';
import 'package:barcode_scanner/objects/ScanException.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget{
  final ScanException _scanException;

  const Error(this._scanException);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Text(AppLocalizations.of(context).errorTitle(_scanException.type), style: Theme.of(context).primaryTextTheme.title,),
        Text(AppLocalizations.of(context).errorMessage(_scanException.type), style: Theme.of(context).primaryTextTheme.body1,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${_scanException.barcode}', style: Theme.of(context).primaryTextTheme.caption,),
        )
      ],
      ),
    );
  }
}