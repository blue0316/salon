import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImagePreview extends StatefulWidget {
  final List<String?>? imageUrls;
  final int index;
  const ImagePreview({Key? key, required this.imageUrls, required this.index}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final PageController _bestWorksController = PageController();
  int _current = 0;

  void setIndex() {
    _current = widget.index;
    Future.delayed(const Duration(microseconds: 300), () {
      _bestWorksController.animateToPage(widget.index, duration: const Duration(microseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  void initState() {
    super.initState();
    setIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.textBlack,
      body: Stack(
        children: [
          PageView(
            controller: _bestWorksController,
            onPageChanged: (val) {
              setState(() {
                _current = val;
              });
            },
            children: [
              for (var string in widget.imageUrls!)
                InteractiveViewer(clipBehavior: Clip.none, child: CachedImage(url: string!)
                    // child: OptimizedCacheImage(
                    //   imageUrl: string!,
                    //   fit: BoxFit.contain,
                    //   memCacheHeight: 400,
                    //   memCacheWidth: 200,
                    //   progressIndicatorBuilder: (context, url, progress) {
                    //     return Center(
                    //         child: SizedBox(
                    //             height: 30,
                    //             width: 30,
                    //             child: CircularProgressIndicator(
                    //               value: progress.progress,
                    //             )));
                    //   },
                    // ),
                    ),
            ],
          ),
          const Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: BackButtonGlassMorphic(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.sp),
                child: SizedBox(
                  height: 20,
                  width: 20 * widget.imageUrls!.length.toDouble() >= 0.8.sw ? 0.8.sw : 20 * widget.imageUrls!.length.toDouble(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageUrls!.length,
                      itemBuilder: (context, index) {
                        return Opacity(
                          opacity: 0.6,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Padding(
                              padding: EdgeInsets.all((index == _current) ? 0 : 5.0),
                              child: SvgPicture.asset(index == _current ? AppIcons.dotActiveSVG : AppIcons.dotInactiveSVG),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
