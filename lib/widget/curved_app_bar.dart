import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

PreferredSizeWidget curvedAppBar({Widget title, bool centerTitle = true, Widget leading}){
  return AppBar(
    leading: leading,
    brightness: Brightness.light,
    centerTitle: true,
    title: title,
    elevation: 0,
    backgroundColor: ThemeColor.primary.withOpacity(0.08),
    shape: CurvedShapeBackground(),
  );
}

class CurvedShapeBackground extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path path = Path();
    path.lineTo(0, rect.height - 10);
    path.quadraticBezierTo(rect.width / 2, rect.height + 50, rect.width, rect.height - 10);
    path.lineTo(rect.width, 0);
    path.close();

    return path;
  }
}