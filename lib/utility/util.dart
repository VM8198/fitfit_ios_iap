import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_fitfit/model/list_of_enum.dart';

class Utility {
  Utility._();
  

  static String _assetPath = "lib/asset/";
  static String iconPath = _assetPath+"icon/";
  static String imagePath = _assetPath+"image/";
  static String emojiPath = _assetPath+"icon/emoji/";
  static String levelPath = _assetPath+"icon/levels/";
  static String soundPath = _assetPath+"sound/";

  static Future eventEnumToString(eventType) async {
    return eventType.toString().split('.')[1];
  }
  
  static Future<void> sendAnalyticsEvent(AnalyticsEventType analyticsEventType, {Map<String, dynamic> param}) async {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    String eventType = await Utility.eventEnumToString(analyticsEventType);

    param != null ? await analytics.logEvent(
      name: eventType,
      parameters: param,
    ) : await analytics.logEvent(name: eventType);
  }

  static String prettifyDurationTime(int durationInSec, {bool abbreviated = true}){
    /// display in X min X sec or X min
    String prettifiedDuration = '';
    String minUnit = abbreviated ? 'min' : 'minutes';
    String secUnit = abbreviated ? 'sec' : 'seconds';

    if(durationInSec <= 60){
      // less than or equal to 1 min
      prettifiedDuration = '$durationInSec $secUnit';
    }
    else{
      int getRemainingSec = durationInSec.remainder(60);
      bool isOnlyMin = getRemainingSec == 0;

      if(isOnlyMin){
        prettifiedDuration = '${Duration(seconds: durationInSec).inMinutes} $minUnit';
      }
      else{
        prettifiedDuration = '${Duration(seconds: durationInSec).inMinutes} $minUnit $getRemainingSec $secUnit';
      }
    }
    return prettifiedDuration;
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}