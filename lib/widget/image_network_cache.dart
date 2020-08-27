import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitfit/widget/empty_holder.dart';

class ImageNetworkCache extends StatelessWidget {

  final String src;
  final double height;
  final double width;
  final BoxFit fit;

  ImageNetworkCache({
    @required this.src,
    this.height,
    this.width,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      placeholder: (context, url) => EmptyHolder(EmptyStateType.image),
      errorWidget: (context, url, error) => EmptyHolder(EmptyStateType.image),
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}