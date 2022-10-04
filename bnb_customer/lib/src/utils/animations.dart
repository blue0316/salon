import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:show_up_animation/show_up_animation.dart';

///provides toggle animation
//for eg when the card expands
class ExpandedSection extends StatefulWidget {
  const ExpandedSection({this.isExpanded = false, required this.child, Key? key}) : super(key: key);

  final Widget child;
  final bool isExpanded;

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}

//see more at https://pub.dev/packages/show_up_animation
/// show_up_animation: ^1.0.2

class SlideInAnimationList extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final Direction direction;
  final int delayStart;
  final int animationDuration;
  final double offSet;

  const SlideInAnimationList(
      {required this.children,
      this.offSet = 0.2,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.direction = Direction.horizontal,
      this.animationDuration = 1000,
      this.delayStart = 100,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(
          children.length,
          (index) => SlideInAnimation(
                index: index,
                offSet: offSet,
                delayStart: delayStart,
                direction: direction,
                animationDuration: animationDuration,
                child: children[index],
              )),
    );
  }
}

class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final int? index;
  final Direction direction;
  final int delayStart;
  final int animationDuration;
  final double offSet;

  const SlideInAnimation({
    required this.child,
    required this.index,
    this.offSet = 0.2,
    this.direction = Direction.horizontal,
    this.animationDuration = 1000,
    this.delayStart = 100,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
      delayStart: Duration(milliseconds: delayStart * (index ?? 1)),
      animationDuration: Duration(milliseconds: animationDuration),
      curve: Curves.easeIn,
      direction: direction,
      offset: offSet,
      child: child,
    );
  }
}

/// Enum to decide the axis on which to animate the [children].
/// To changing the animation direction on the axis, consider using a negative offset.
// enum Direction {
//   /// Animate along the vertical y-axis
//   vertical,
//
//   /// Animate along the horizontal x-axis
//   horizontal,
// }

class LoadingScreen {
  bool loading = false;

  // test() {
  //   loading ? stop() : start();
  // }

  void start() async {
    if (!loading) {
      loading = true;
      showCustomLoadingWidget(const LoadingAnimation(),
          // Center(
          //     child: Container(
          //   height: 300,
          //   width: 300,
          //   decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(24)),
          //
          //   child: Image.asset(AppIcons.loadingIcon,height: 200,),
          // )
          // ),
          tapDismiss: false);
      Future.delayed(const Duration(seconds: 5), () {
        loading = false;
        hideLoadingDialog();
      });
    }
  }

  stop() {
    if (loading) {
      hideLoadingDialog();
      loading = false;
    }
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppIcons.locationCurrentSVG,
      height: 200,
    );
  }
}

class ShowDoneAnimation {
  OverlayState? overlayState;
  late OverlayEntry overlayEntry;
  bool loading = false;

  void start(context) async {
    if (!loading) {
      loading = true;
      overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) => Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: Image.asset(
                  AppIcons.done1GIF,
                ),
              ));
      overlayState!.insert(overlayEntry);
      Future.delayed(const Duration(seconds: 5), () {
        stop();
      });
    }
  }

  stop() {
    if (loading) {
      overlayEntry.remove();
      loading = false;
    }
  }
}
