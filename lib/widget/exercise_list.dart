import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/screen/favorite_dialog.dart';
import 'package:flutter_fitfit/widget/empty_holder.dart';
import 'package:flutter_fitfit/widget/image_network_cache.dart';

class ExerciseList extends StatelessWidget{
  ExerciseList({
    this.withLeading = true,
    this.imgList,
    this.withCaption = true,
    this.onImageTap,
    this.withFavIcon = true,
    this.onFavIconTap,
    this.withLrPadding = true,
    this.tapSplash = true,
  });

  final bool withLeading;
  final List<ExerciseSliderModel> imgList;
  final bool withCaption;
  final Function onImageTap;
  final bool withFavIcon;
  final Function onFavIconTap;
  final bool withLrPadding;
  final bool tapSplash;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: 
        imgList.asMap().entries.map<Widget>((entry){
          int index = entry.key;
          ExerciseSliderModel item = entry.value;

          return InkWell(
            onTap: () => onImageTap != null ? onImageTap({'items': item, 'index': index}) : null,
            splashColor: tapSplash ? Theme.of(context).splashColor : Colors.transparent,
            highlightColor: tapSplash ? Theme.of(context).highlightColor : Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: withLrPadding ? 16.0 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  withLeading ? Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _leading(item.thumbnail),
                  ) : const SizedBox(),
                  _content(item.title, item.desc),
                  // withFavIcon ? _favIcon(context) : const SizedBox()
                ],
              ),
            ),
          );
        }).toList(),
    );
  }

  Widget _leading(String thumbnail){
    return DecoratedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: SizedBox(
          width: 72.0,
          height: 72.0, 
          child: thumbnail != null ?  ImageNetworkCache(
            src: thumbnail, 
            fit: BoxFit.fitHeight,
          ) : EmptyHolder(EmptyStateType.image)
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(4.0,10.0)
          )
        ]
      ),
    );
  }

  Widget _content(String title, String desc){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: NunitoStyle.body1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              desc,
              style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _favIcon(BuildContext context){
  //   return IconButton(
  //     icon: Icon(Icons.favorite_border),
  //     color: ThemeColor.black[24],
  //     onPressed: () => showDialog(
  //       context: context,
  //       child: FavoriteDialog()
  //     ),
  //   );
  // }
}