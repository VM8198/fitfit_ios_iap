import 'package:flutter/material.dart';
import 'package:flutter_fitfit/utility/util.dart';

enum EmptyStateType{image,video}

class EmptyHolder extends StatelessWidget{
  final EmptyStateType type;

  EmptyHolder(this.type);

  @override
  Widget build(BuildContext context) {
    if(type == EmptyStateType.image){
      return Image.asset(
        Utility.imagePath + 'placeholder_200x200.png',
        fit: BoxFit.fitWidth,
      );
    }
    else if(type == EmptyStateType.video){
      return Image.asset(
        Utility.imagePath + 'placeholder_600x600.png',
        fit: BoxFit.fitWidth,
      );
    }
    return null;
  }
}