import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/screen/favorite_dialog.dart';

class FavoriteButton extends StatelessWidget{
  final bool isFavorited;
  final Function onTap;

  FavoriteButton({this.isFavorited = false,this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border
      ),
      color: isFavorited ? ThemeColor.favoriteRed : ThemeColor.black[24],
      onPressed: () => isFavorited ? _showUnfavoriteNotification(context) : _showDialog(context),
    );
  }

  void _showDialog(BuildContext context){
    showDialog(
      context: context,
      child: FavoriteDialog()
    );
    onTap();
  }

  void _showUnfavoriteNotification(BuildContext context){
    Flushbar(
      messageText: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.favorite,
              color: ThemeColor.favoriteRed,
            ),
          ),
          Text(
            'Successfully remove from favourite!',
            style: NunitoStyle.body2,
          )
        ],
      ),
      backgroundColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 500),
    ).show(context);

    onTap();
  }

}