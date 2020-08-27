import 'package:flutter/services.dart';
import 'package:flutter_fitfit/utility/util.dart';
import 'package:soundpool/soundpool.dart';

class SoundPlayer {
  static Soundpool _soundpool = Soundpool();
  static int soundId;
  
  static Future<void> play() async{
    if(soundId == null){
      var asset = await rootBundle.load(Utility.soundPath + 'ding.aac');
      Future<int> _soundId = _soundpool.load(asset);
      soundId = await _soundId;
    }
    _soundpool.play(soundId);    
  }
}
