import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:barcode_scanner/objects/ScanException.dart';
import '../Localization.dart';
import '../MainModel.dart';
import '../objects/flower.dart';
import '../widgets/FlowerCard.dart';
import '../widgets/Error.dart';

class FlowerPage extends StatefulWidget {
  final String barcode;
  final Function getFlower;

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
  ExceptionType _errorType;

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
    }on ScanException catch(e){
      setState(() {
        _errorType = e.type;
        _status = Status.ERROR;
      });
      return;
    }catch (e){
      setState(() {
        _errorType = ExceptionType.UNKNOWN_ERROR;
        _status = Status.ERROR;
      });
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

  Widget _bodyWidget() {
    if (_status == Status.LOADING) {
      return Center(child: CircularProgressIndicator());
    } else if (_status == Status.ERROR) {
      return Error(_errorType);
    } else {
      return FlowerCard(_flower);
    }
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
