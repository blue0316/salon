import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/icons.dart';

class MasterAllWorks extends StatefulWidget {
  final MasterModel master;

  const MasterAllWorks({Key? key, required this.master}) : super(key: key);
  @override
  _MasterAllWorksState createState() => _MasterAllWorksState();
}

class _MasterAllWorksState extends State<MasterAllWorks> {
  int gridViewChildCount = 12;

  final ScrollController _gridViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.0.w, right: 28.w, top: 28.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${AppLocalizations.of(context)?.all ?? "all"} (${widget.master.photosOfWork?.length ?? 0})"),
              SizedBox(
                width: 16.w,
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //       height: 32.w,
              //       width: 32.w,
              //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              //       child: Padding(
              //         padding: EdgeInsets.all(8.0.w),
              //         child: SvgPicture.asset(AppIcons.lensBlackSVG),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 16.w,
              //     ),
              //     Container(
              //       height: 32.w,
              //       width: 32.w,
              //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              //       child: Padding(
              //         padding: EdgeInsets.all(8.0.w),
              //         child: SvgPicture.asset(AppIcons.filterBlackSVG),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        (widget.master.photosOfWork != null && (widget.master.photosOfWork?.isNotEmpty ?? false))
            ? GridView.builder(
                gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DeviceConstraints.getResponsiveSize(context, 2, 3, 4).toInt(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                shrinkWrap: true,
                primary: false,
                itemCount: widget.master.photosOfWork!.length,
                controller: _gridViewScrollController,
                padding: EdgeInsets.all(20.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImagePreview(
                                    imageUrls: widget.master.photosOfWork,
                                    index: index,
                                  )));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:CachedImage( url: widget.master.photosOfWork![index],),

                    ),
                  );
                }) : SizedBox(
                height: 0.5.sh,
              )
      ],
    );
  }
}
