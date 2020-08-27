
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Image image;
  final bool selected;

  CircleButton({Key key, this.onTap, this.image, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _size = 100.0;

    return InkResponse(
      onTap: () => onTap(),
      radius: _size / 1.5,
      child: Stack(
        children: <Widget>[
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_size),
              border: selected ? Border.all(color: ThemeColor.primaryDark, width: 2.0) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10.0,
                  spreadRadius: 0,
                  offset: Offset(4.0,10.0)
                )
              ]
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 40,
                child: image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
