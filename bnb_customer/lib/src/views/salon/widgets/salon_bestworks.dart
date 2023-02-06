import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/salon_master/salon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonBestWorks extends StatefulWidget {
  final SalonModel salonModel;

  const SalonBestWorks({Key? key, required this.salonModel}) : super(key: key);
  @override
  _SalonBestWorksState createState() => _SalonBestWorksState();
}

class _SalonBestWorksState extends State<SalonBestWorks> {
  final ScrollController _bestWorksScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0.w, top: 28, bottom: DeviceConstraints.getResponsiveSize(context, 12, 18, 24)),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)?.bestWorks ?? "BestWorks",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0.w),
          child: SizedBox(
            height: 140.h,
            child: ListView.builder(
                controller: _bestWorksScrollController,
                itemCount: widget.salonModel.photosOfWork.isNotEmpty ? widget.salonModel.photosOfWork.length : 3,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 16.0.w,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        child: widget.salonModel.photosOfWork.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImagePreview(
                                          imageUrls: widget.salonModel.photosOfWork,
                                          index: index,
                                        ),
                                      ));
                                },
                                child: CachedImage(
                                  url: widget.salonModel.photosOfWork[index],
                                  height: 140.h,
                                  cacheWidth: 180,
                                ))
                            : const SizedBox(),
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
