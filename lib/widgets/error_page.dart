import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget{

  final String error;

  ErrorPage(this.error);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ERROR!'));
  }

}