import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_main_theme.dart';

class DefaultButton extends StatelessWidget {
  final String? label;
  final Function? onTap;
  final bool isLoading;
  final Color? color;
  final double height;
  const DefaultButton({Key? key, this.label, this.onTap, this.isLoading = false, this.color, this.height = 60}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            height: height,
            // size.width - 94,
            minWidth: double.infinity,
            color: color ?? AppTheme.lightBlack,
            disabledColor: AppTheme.coolGrey,
            onPressed: onTap as void Function()?,
            child: Text(
              label ?? "Sign up",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
          );
  }
}

class DropDownObject extends StatefulWidget {
  final List<Object>? list;
  final preSelected;
  final Function? onChanged;
  final Function? child;

  const DropDownObject({Key? key, this.list, this.preSelected, this.onChanged, this.child}) : super(key: key);

  @override
  _DropDownObjectState createState() => _DropDownObjectState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownObjectState extends State<DropDownObject> {
  var dropdownValue;

  @override
  void initState() {
    super.initState();
    _assignInitialValue();
  }

  _assignInitialValue() {
    if (widget.preSelected == null) {
      dropdownValue = widget.list!.first;
    } else {
      dropdownValue = widget.preSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Object>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      underline: Container(
        color: Theme.of(context).primaryColor,
        height: 1,
      ),
      onChanged: (Object? val) {
        setState(() {
          dropdownValue = val;
        });
        if (widget.onChanged != null) widget.onChanged!(val);
      },
      items: widget.list!.map<DropdownMenuItem<Object>>((Object value) {
        return DropdownMenuItem<Object>(
          value: value,
          child: widget.child!(value),
        );
      }).toList(),
    );
  }
}

class BnbMaterialButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final double? minWidth;
final EdgeInsets? padding;
  const BnbMaterialButton({Key? key, required this.onTap, required this.title, required this.minWidth, this.padding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(padding: padding??EdgeInsets.symmetric(horizontal: 12,vertical: 16),
      onPressed: onTap as void Function()?,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppTheme.creamBrown,

      minWidth: minWidth,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class BnbCheckCircle extends StatefulWidget {
  final bool value;
  const BnbCheckCircle({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _BnbCheckCircleState createState() => _BnbCheckCircleState();
}

class _BnbCheckCircleState extends State<BnbCheckCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      width: 24.h,
      decoration: BoxDecoration(
          border: Border.all(
            color: widget.value ? AppTheme.textBlack : AppTheme.coolGrey,
          ),
          shape: BoxShape.circle,
          color: widget.value ? AppTheme.textBlack : Colors.transparent),
      child: Icon(
        Icons.check_rounded,
        color: widget.value ? Colors.white : Colors.transparent,
        size: 18,
      ),
    );
  }
}

class BackButtonGlassMorphic extends StatelessWidget {
  const BackButtonGlassMorphic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>Navigator.of(context).maybePop(),
      child: Container(
        height: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
        width: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
        decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(DeviceConstraints.getResponsiveSize(context, 4, 6, 8)),
          child: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
