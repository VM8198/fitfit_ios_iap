import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum LogoType{
  transparent,
  normal
}

class Logo extends StatelessWidget{
  final LogoType type;
  final double width;

  Logo({this.type,this.width});

  @override
  Widget build(BuildContext context) {
    double _width = width != null ? width : 80.0;

    switch (type) {
      case LogoType.transparent:
        return SvgPicture.asset(
          'lib/asset/image/logo_transparent.svg',
          width: _width,
          height: _width,
        );
        break;
      default:
        return SvgPicture.asset(
          'lib/asset/image/logo.svg',
          width: _width,
          height: _width,
        );
    }
  }
}