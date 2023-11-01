import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/chat/image_preview.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterAllWorks extends ConsumerStatefulWidget {
  final MasterModel master;

  const MasterAllWorks({Key? key, required this.master}) : super(key: key);
  @override
  _MasterAllWorksState createState() => _MasterAllWorksState();
}

class _MasterAllWorksState extends ConsumerState<MasterAllWorks> {
  int gridViewChildCount = 12;

  final ScrollController _gridViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Space(factor: 1.5),
                    Text(
                      (masterTitles(AppLocalizations.of(context)?.localeName ?? 'en')[2]).toUpperCase(),
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 35.sp),
                        color: isLightTheme ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Space(factor: 2.5),
                    (widget.master.photosOfWork != null && (widget.master.photosOfWork?.isNotEmpty ?? false))
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: DeviceConstraints.getResponsiveSize(context, 1, 2, 3).toInt(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: DeviceConstraints.getResponsiveSize(context, 10, 10, 10),
                              mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 250.h, 200.h, 200.h), // childAspectRatio: 1,
                              // mainAxisExtent: DeviceConstraints.getResponsiveSize(context, 0, 0, 256),
                            ),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: widget.master.photosOfWork!.length,
                            controller: _gridViewScrollController,
                            // padding: EdgeInsets.all(20.w),
                            itemBuilder: (context, index) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImagePreview(imageUrls: widget.master.photosOfWork, index: index),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: DeviceConstraints.getResponsiveSize(context, 250, 200, 100),
                                          width: isPortrait ? double.infinity : DeviceConstraints.getResponsiveSize(context, 200, 300, 400),
                                          // decoration: const BoxDecoration(color: Colors.green),
                                          child: CachedImage(
                                            url: widget.master.photosOfWork![index],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                      // const SizedBox(height: 10),
                                      // Text(
                                      //   (widget.master.photosOfWork![index]. .description != null && widget.master.photosOfWork![index].description != '') ? '${widget.master.photosOfWork![index].description}' : '...',
                                      //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal, fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 15.sp), color: Colors.black),
                                      //   maxLines: 2,
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
                                      // const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                              'NO PHOTOS OF WORKS AVAILABLE AT THE MOMENT',
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                    color: isLightTheme ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
