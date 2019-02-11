import 'package:flutter/material.dart';

class Error extends StatelessWidget{
  final String _title;
  final String _message;

  const Error(this._title, this._message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Text(_title, style: Theme.of(context).primaryTextTheme.title,),
        Text(_message, style: Theme.of(context).primaryTextTheme.body1,)
      ],
      ),
    );
  }
}