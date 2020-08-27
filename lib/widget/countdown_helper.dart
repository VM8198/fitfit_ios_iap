// Dart libs
import 'dart:async';

// Flutter libs
import 'package:flutter/widgets.dart';

///
/// Simple count down (timer)
///
class CountDownHelper extends StatefulWidget {
  // Seconds
  final int seconds;

  // Callback when timer is done
  final VoidCallback onTimer;

  // Callback when countdown is running
  final Function onTicking;

  // Duration
  final Duration duration;

  // Style of text
  final TextStyle style;

  final bool onPause;

  final bool showSecondsOnly;

  ///
  /// Simple count down (timer)
  ///
  CountDownHelper({
    Key key,
    @required this.seconds,
    this.onTimer,
    this.onTicking(int sec),
    this.duration = const Duration(seconds: 1),
    this.style = const TextStyle(),
    this.onPause = false,
    this.showSecondsOnly = false
  }) : super(key: key);

  @override
  _CountDownHelperState createState() => _CountDownHelperState();
}

///
/// Count down state
///
class _CountDownHelperState extends State<CountDownHelper> {
  // Timer
  Timer _timer;

  // Current seconds
  int _currentSeconds;

  @override
  void initState() {
    _currentSeconds = widget.seconds;

    _timer = Timer.periodic(
      widget.duration,
      // Run callback with custom [duration]
      (Timer timer) {
        if( !widget.onPause ){
          if (_currentSeconds < 1) {
          // In this case timer whill be done
          // Thas why we do not need check it on build function

          // Stop timer
          timer.cancel();

          // Call callback if not null
          if (widget.onTimer != null) {
            widget.onTimer();
          }
        } else {
          
          setState(() {
            // TIP: _currentSeconds -= 1 make insane!
            _currentSeconds = _currentSeconds - 1;
          });
          widget.onTicking(_currentSeconds);
        }
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _getRoot(context);

  ///
  /// Build root of widget
  ///
  Widget _getRoot(BuildContext context) {
    return Container(
      child: _buildCountDown(context),
    );
  }

  ///
  /// Build count down timer
  ///
  Text _buildCountDown(BuildContext context) {
    int minutes = (_currentSeconds / 60).floor();
    String minutesString = minutes.toString().padLeft(2, '0');

    int tempSeconds = (_currentSeconds - (minutes * 60));
    int seconds = tempSeconds > 60 ? (tempSeconds / 60).floor() : tempSeconds;
    String secondsString = seconds.toString().padLeft(2, '0');

    if(widget.showSecondsOnly){
      return Text(
        '$secondsString',
        style: widget.style,
      );
    }
    else{
      return Text(
        '$minutesString:$secondsString',
        style: widget.style,
      );
    }
  }
}
