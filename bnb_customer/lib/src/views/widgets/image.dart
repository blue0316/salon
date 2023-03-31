import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final PlaceholderWidgetBuilder? placeHolder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final int? cacheWidth;
  final BoxFit? fit;
  const CachedImage({Key? key, required this.url, this.height, this.width, this.cacheWidth, this.placeHolder, this.errorWidget, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final _cachedWidth = (cacheWidth ?? width?.round() ?? 800) * _devicePixelRatio.round();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit ?? BoxFit.cover,

      height: height,
      width: width,

      //maxHeightDiskCache: 800,
      errorWidget: (context, url, error) {
        print('image eorror $error');
        return SizedBox(
        height: height,
        width: width,
        // decoration: BoxDecoration(shape: BoxShape.circle),
        child: Center(
          child: Icon(
            Icons.error,
            size: height,
            color: Colors.red,
          ),
        ),
      );},
      placeholder: placeHolder,
      memCacheWidth:500,
    );
  }
}
