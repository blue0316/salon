import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VintageCraftTeamMember extends ConsumerStatefulWidget {
  final String? name, image;
  final MasterModel master;
  final String? masterTitle;
  final bool showDesc;

  const VintageCraftTeamMember({
    Key? key,
    required this.name,
    required this.masterTitle,
    required this.image,
    required this.master,
    this.showDesc = false,
  }) : super(key: key);

  @override
  ConsumerState<VintageCraftTeamMember> createState() => _VintageCraftTeamMemberState();
}

class _VintageCraftTeamMemberState extends ConsumerState<VintageCraftTeamMember> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 2, bottom: 2, left: 2),
      child: GestureDetector(
        onTap: () {
          // _createAppointmentProvider.setMaster(
          //   masterModel: widget.master,
          //   categories: _salonSearchProvider.categories,
          // );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UniqueMasterProfile(
          //       masterModel: widget.master,
          //     ),
          //   ),
          // );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => onEntered(true),
          onExit: (event) => onEntered(false),
          child: SizedBox(
            width: DeviceConstraints.getResponsiveSize(
              context,
              (size.width - 40.w),
              (size.width - 100.w),
              ((size.width - 100.w - 60) / 3),
            ),
            // decoration: BoxDecoration(
            //   color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
            //   border: Border.all(color: (themeType == ThemeType.GentleTouch) ? Colors.black : const Color(0XFF868686), width: 0.4),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
                    //   border: Border(
                    //     bottom: BorderSide(
                    //       color: (themeType == ThemeType.GentleTouch) ? Colors.black : const Color(0XFF868686),
                    //       width: 0.4,
                    //     ),
                    //   ),
                    // ),
                    child: (widget.image != null && widget.image != '')
                        ? ClipRect(
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                              child: CachedImage(
                                url: widget.image!,
                                fit: BoxFit.cover,
                                color: !isHovered ? Colors.grey[850] : null,
                                colorBlendMode: BlendMode.saturation,
                              ),
                            ),
                          )
                        : Image.asset(
                            ThemeImages.noTeamMemberDark,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 12.sp),
                Text(
                  (widget.name ?? '').toUpperCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isHovered ? theme.colorScheme.secondary : Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
                // SizedBox(height: 5.sp),
                if (widget.masterTitle!.isNotEmpty) SizedBox(height: 2.sp),
                Text(
                  (widget.masterTitle ?? '').toTitleCase(),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                    color: const Color(0XFF868686),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
