import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewChip extends ConsumerWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const ReviewChip({Key? key, required this.title, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor : Colors.brown,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                  color: selected ? Colors.white : const Color(0XFF1E3354),
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (selected) const SizedBox(width: 5),
              if (selected) Icon(Icons.close_rounded, color: Colors.white, size: 17.sp),
            ],
          ),
        ),
      ),
    );
  }
}
