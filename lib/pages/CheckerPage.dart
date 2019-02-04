import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../Localization.dart';
import '../MainModel.dart';

class CheckerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckerPageState();
  }
}

class CheckerPageState extends State<CheckerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller =
      TextEditingController(text: '5500009866193');

  void _searchByText(){
    if (_formKey.currentState.validate()) {
      Navigator.pushNamed(context, '/flowers/${controller.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).priceChecker),
        ),
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/logo7fl.jpg'),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (_){_searchByText();},
                              controller: controller,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .barcodeSearchFieldTitle),
                              maxLength: 13,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.length < 13) {
                                  return AppLocalizations.of(context)
                                      .errorBarcodeLength;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          RaisedButton(
                            child: Text(
                              AppLocalizations.of(context).search.toUpperCase(),
                              style: Theme.of(context).textTheme.button,
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: () {_searchByText();},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Image.asset("assets/barcode-scan.png"),
            onPressed: () {
              model.scanBarcodeOnCamera().then((String barcode) {
                if (barcode.isEmpty) return;
                Navigator.pushNamed(context, '/flowers/$barcode');
              });
            }),
      );
    });
  }

}
