import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class MediaController extends StatelessWidget{
  final Function onPlayOrPause;
  final Function onSkip;
  final Function onPrevious;
  final bool isPlaying;
  final bool showPlayOrPauseIcon;
  final Widget middleWidget;

  MediaController({
    this.isPlaying = true, 
    this.onPlayOrPause, 
    this.onSkip, 
    this.onPrevious,
    this.showPlayOrPauseIcon = true,
    this.middleWidget
  }) : assert(showPlayOrPauseIcon == false ? middleWidget != null : true);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RadiantGradientMask(
          child: IconButton(
            icon: Icon(Icons.skip_previous),
            color: Colors.white,
            iconSize: 32.0,
            onPressed: () => onPrevious(),
          ),
        ),
        showPlayOrPauseIcon ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ThemeColor.fusion01,
            ),
            borderRadius: BorderRadius.circular(100.0)
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow
            ),
            color: ThemeColor.white,
            iconSize: 40.0,
            onPressed: () => onPlayOrPause(),
          ),
        ) : middleWidget,
        RadiantGradientMask(
          child: IconButton(
            icon: Icon(Icons.skip_next),
            color: Colors.white,
            iconSize: 32.0,
            onPressed: () => onSkip(),
          ),
        ),
      ],
    );
  }
}


class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: ThemeColor.fusion01,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
