import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/fitfit_icon.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/model/exercise_slider.dart';
import 'package:flutter_fitfit/widget/empty_holder.dart';
import 'package:flutter_fitfit/widget/image_network_cache.dart';

enum SliderCaptionStyle{normal,overlay}

class ExerciseSlider extends StatelessWidget {
  ExerciseSlider({
    this.imgList,
    this.withCaption = true,
    this.onImageTap,
    this.captionStyle = SliderCaptionStyle.normal,
  });

  final List<ExerciseSliderModel> imgList;
  final bool withCaption;
  final Function onImageTap;
  final SliderCaptionStyle captionStyle;
  final double fraction = 0.4;

  // @override
  // Widget build(BuildContext context) {    
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Padding(
  //       padding: EdgeInsets.only(bottom: 24.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: List<Widget>.generate(imgList.length, (idx){
  //           return buildCarouselItem(context, idx, imgList.length);
  //         }),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final extraHeight = withCaption && captionStyle == SliderCaptionStyle.normal ? 70.0 : 0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: (((MediaQuery.of(context).size.width * fraction) * 3 / 4) + extraHeight ),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: imgList.length,
        itemBuilder: (BuildContext ctxt, int index) => buildCarouselItem(ctxt, index, imgList.length),
      ),
    );
  }

  Widget buildCarouselItem(BuildContext ctxt, int index, int length) {
    bool shouldLeftPadded = index == 0;
    bool shouldRightPadded = index == length - 1;
    double padding = 16.0;

    return Container(
      width: MediaQuery.of(ctxt).size.width * fraction,
      margin: shouldLeftPadded ? EdgeInsets.only(left: padding, right: padding/2) : (shouldRightPadded ? EdgeInsets.only(left: padding/2, right: padding) : EdgeInsets.symmetric(horizontal: padding/2)),
      child: Column(
        children: <Widget>[
          DecoratedBox(
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
            child: GestureDetector(
              onTap: () => onImageTap != null ? onImageTap(index: index) : null,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: imgList[index].thumbnail != null ? ImageNetworkCache(
                              src: imgList[index].thumbnail,
                              fit: BoxFit.cover,
                            ): EmptyHolder(EmptyStateType.image),
                          ),
                          Visibility(
                            visible: withCaption && captionStyle == SliderCaptionStyle.overlay,
                            child: Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [ThemeColor.black[80],Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: ThemeColor.background.withOpacity(0.6)
                                ),
                                child: Icon(
                                  FitFitIcon.check_circle,
                                  color: ThemeColor.secondaryDark,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Visibility(
                      visible: withCaption && captionStyle == SliderCaptionStyle.overlay,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextOneLine(
                              imgList[index].title != null ? imgList[index].title : '',
                              style: NunitoStyle.title2.copyWith(color: Colors.white),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              imgList[index].desc,
                              style: NunitoStyle.caption2.copyWith(color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: imgList[index].isCompleted,
                    child: Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: ThemeColor.background.withOpacity(0.6)
                          ),
                        ),
                      )
                    ),
                  ),
                  Visibility(
                    visible: imgList[index].isCompleted,
                    child: Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: imgList[index].checkedColor != null ? imgList[index].checkedColor : ThemeColor.primary,
                          size: 40,
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: withCaption && captionStyle == SliderCaptionStyle.normal,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextOneLine(
                          imgList[index].title != null ? imgList[index].title : '', 
                          style: NunitoStyle.body1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis
                        ),
                        Text(
                          imgList[index].desc,
                          style: NunitoStyle.body2.copyWith(color: ThemeColor.black[56]),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
