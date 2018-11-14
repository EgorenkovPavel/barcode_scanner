import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final Function scan;
  final Function getGoodInfo;
  final TextEditingController controller = TextEditingController();

  StartPage(this.scan, this.getGoodInfo);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo7fl.jpg'),
          Text('Press the button and scan barcode'),
          Text('or'),
          Text('type it in text field'),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(helperText: 'Enter barcode'),
                      maxLength: 13,
                      keyboardType:
                          TextInputType.number,
                      validator: (String value){
                        if(value.length < 13){
                          return 'Barcode has length 13 symbols';
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16.0,),
                  RaisedButton(
                    child: Text('Search', style: TextStyle(color: Colors.white),),
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        getGoodInfo(controller.text);
                      }
                    },)
                ],
              ),
            ),
          ),
          RaisedButton(child: Text('Scan', style: TextStyle(color: Colors.white),) ,
            color: Theme.of(context).primaryColor,
            onPressed: (){
              scan();
            },)
        ],
    );
  }
}
