import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../MainModel.dart';
import '../objects/flower.dart';

class FlowerList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return ListView.builder(
          itemCount: model.flowerList.length,
          itemBuilder: (BuildContext context, int position){
            Flower flower = model.flowerList[position];

            return ListTile(
              leading: CircleAvatar(child: Image.asset(flower.photoPath),),
              title: Text(flower.title),
              trailing: Text('$flower.regularPrice'), //replace with price widget
            );
          },
        );
      },
    );
  }
}