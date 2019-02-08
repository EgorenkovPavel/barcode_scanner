import 'package:barcode_scanner/widgets/Price.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../MainModel.dart';
import '../objects/flower.dart';
import '../ConnectionSettings.dart';

class FlowerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemCount: model.flowerList.length,
          itemBuilder: (BuildContext context, int position) {
            Flower _flower = model.flowerList[position];

            return ListTile(
              leading: CircleAvatar(
                child: Image.network(_flower.photoPath,
                    headers: ConnectionSettings.headers),
              ),
              title: Text(_flower.title),
              subtitle: Text(_flower.barcode),
              trailing: Price(_flower, 16),
              onTap: (){
                Navigator.pushNamed(context, '/flowers/${_flower.barcode}');
              },//replace with price widget
            );
          },
        );
      },
    );
  }
}
