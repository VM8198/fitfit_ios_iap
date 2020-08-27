import 'package:flutter/material.dart';
import 'package:flutter_fitfit/asset/theme/theme_color.dart';

class ScrollPageCustomTemplate extends StatelessWidget{
  final Widget header;
  final Widget content;
  final Widget bottomNavigationBar;
  
  ScrollPageCustomTemplate({this.header, this.content,this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: ThemeColor.background,
              pinned: true,
              expandedHeight: size.width * 9 / 11,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: <Widget>[
                    header,
                    Positioned(
                      bottom: -5,
                      child: Container(
                        width: size.width,
                        height: 20.0,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0),)
                        ),
                      ),
                    )
                  ]
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  content
                ]
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar
    );
  }

}