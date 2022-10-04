import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaloonAllWorks extends StatefulWidget {
  final SalonModel salonModel;

  const SaloonAllWorks({Key? key, required this.salonModel}) : super(key: key);
  @override
  _SaloonAllWorksState createState() => _SaloonAllWorksState();
}

class _SaloonAllWorksState extends State<SaloonAllWorks> {
  int gridViewChildCount = 12;

  final ScrollController _gridViewScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.0.w, right: 28.w, top: 28.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "${AppLocalizations.of(context)?.all ?? 'all'} (${widget.salonModel.photosOfWork.length})"),
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
        (widget.salonModel.photosOfWork.isNotEmpty)
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      DeviceConstraints.getResponsiveSize(context, 2, 3, 4)
                          .toInt(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                shrinkWrap: true,
                primary: false,
                itemCount: widget.salonModel.photosOfWork.length,
                controller: _gridViewScrollController,
                padding: EdgeInsets.all(20.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImagePreview(
                                    imageUrls: widget.salonModel.photosOfWork,
                                    index: index,
                                  )));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedImage(
                            url: widget.salonModel.photosOfWork[index])),
                  );
                })
            : SizedBox(
                height: 0.5.sh,
              )
      ],
    );
  }
}
