import 'package:flutter/material.dart';
import 'package:flutter_fitfit/widget/empty_holder.dart';
import 'package:flutter_fitfit/widget/image_network_cache.dart';

class ScrollPageTemplate extends StatelessWidget{
  final String backgroundUrl;
  final Widget content;
  final Widget bottomNavigationBar;
  
  ScrollPageTemplate(this.backgroundUrl,{this.content,this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: size.width * 9 / 16,
              leading: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.4),
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 24,
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: backgroundUrl != null ? ImageNetworkCache(
                        src: backgroundUrl,
                        fit: BoxFit.cover,
                      ) : EmptyHolder(EmptyStateType.image),
                    ),
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