import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/nunito_style.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';
import 'package:flutter_fitfit/screen/question.dart';
import 'package:flutter_fitfit/utility/nav.dart';
import 'package:flutter_fitfit/widget/cta_button.dart';
import 'package:flutter_fitfit/widget/image_network_cache.dart';

class PtNonSubscriberCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'My Training',
              textAlign: TextAlign.center,
              style: NunitoStyle.h4,
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0,
                    spreadRadius: 0,
                    offset: Offset(4.0,10.0)
                  )
                ]
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: ImageNetworkCache(
                        src: 'https://d37lq49mekhjll.cloudfront.net/app-asset/pt_banner.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Get your very own Smart Personal Training plan with automatic progression.',
                                textAlign: TextAlign.center,
                                style: NunitoStyle.title2.copyWith(color: ThemeColor.black[100]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16,bottom: 24),
                                child: Text(
                                  'Day one or one day, you decide 😉',
                                  textAlign: TextAlign.center,
                                  style: NunitoStyle.body2.copyWith(color: ThemeColor.black[80]),
                                ),
                              ),
                              CtaButton(
                                'I\'m in!',
                                onPressed: (_) => Nav.navigateTo(QuestionPage.routeName),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}